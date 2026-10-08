package com.koreab2b.mro.master.mdcm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemChangeReqService;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsItemService;
import com.koreab2b.mro.util.CommonUtil;

/**
 * 상품정보 수정요청
 *  - 현황 화면(요청자) 조회 · 요청 등록 · 요청취소
 *  - 저장 테이블 : CMSCATLG_REQ / CMSCATLG_REQ_DT
 *  - DB관리파트 승인화면은 아직 없다 - 승인/반려는 여기 없다.
 */
@Controller("masterMdCmCmsItemChangeReqController")
public class MasterMdCmCmsItemChangeReqController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsItemChangeReqController.class);

	/* 요청 1건에 담을 수 있는 변경항목 상한.
	 * 화면이 받는 변경항목은 9개뿐이지만, 파라미터가 조작돼 들어오는 경우를 막는다. */
	private static final int MAX_CHANGE_ITEMS = 20;

	/* DB관리파트 판정.
	 * ICOMCOD3 기능스위치 관용구 - CODE1 = userId, BUYER = 운영사. 부서축(SOURDEPT)과 달리
	 * 사람 단위로 넣고 빼야 하는 성격이라 부서코드로는 판단할 수 없다.
	 * ⚠ 이 TYPE 은 아직 적재되지 않았다 → 아무도 통과하지 못한다.
	 *   그래서 아래 개발자 계정 예외가 임시로 필요하다(목록·상세팝업에 있는 같은 성격의 예외와 짝). */
	private static final String DB_PART_CODE_TYPE = "CDBM";
	private static final String OPER_BUYER        = "KRKORE0001";
	private static final String TEMP_DB_PART_USER = "KEP2239016";

	@Autowired
	private MasterMdCmCmsItemChangeReqService masterMdCmCmsItemChangeReqService;

	@Autowired
	private MasterMdCmCmsItemService masterMdCmCmsItemService;

	/* 현황 목록 조회.
	 * ★ 본인이 낸 요청만 보인다 - 로그인 사용자를 여기서 못 박는다(화면이 보낸 값은 신뢰하지 않는다). */
	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemChangeReqStatusList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchStatusList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_login_user_id", (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId()));

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemChangeReqService.getStatusList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	/**
	 * 수정요청 등록.
	 * 상세팝업 [요청] → 상태변경 팝업이 사유를 받아 여기로 보낸다.
	 * 변경항목은 병렬 파라미터(st_job_column · st_old_data · st_new_data · …)로 온다 -
	 * 순서가 곧 REQ_SEQ 라 리스트 길이가 어긋나면 값이 밀린다. 길이를 먼저 맞춰 본다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemChangeReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveChangeReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code", 0);
		_response.put("Result", mp);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _userId = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId());
		if ("".equals(_userId)) {
			_response.put("Message", "로그인 정보가 없습니다. 다시 로그인해 주세요.");
			return _response;
		}

		String _catlgId = firstValue(pMap, "st_catlg_id");
		if ("".equals(_catlgId)) {
			_response.put("Message", "상품정보코드가 없습니다.");
			return _response;
		}

		List<String> _jobColumns = valueList(pMap, "st_job_column");
		if (_jobColumns.isEmpty()) {
			_response.put("Message", "변경된 항목이 없습니다.");
			return _response;
		}
		if (_jobColumns.size() > MAX_CHANGE_ITEMS) {
			_response.put("Message", "한 번에 요청할 수 있는 변경항목 수를 넘었습니다.");
			return _response;
		}

		List<String> _oldData      = valueList(pMap, "st_old_data");
		List<String> _newData      = valueList(pMap, "st_new_data");
		List<String> _reasonCode   = valueList(pMap, "st_reason_code");
		List<String> _reasonRemark = valueList(pMap, "st_reason_remark");
		List<String> _altCode      = valueList(pMap, "st_alt_code");

		List<Map<String,String>> _items = new ArrayList<Map<String,String>>();
		for (int i = 0; i < _jobColumns.size(); i++) {
			Map<String,String> _item = new HashMap<String,String>();
			_item.put("st_job_column",    CommonUtil.nvl(_jobColumns.get(i)));
			_item.put("st_old_data",      at(_oldData, i));
			_item.put("st_new_data",      at(_newData, i));
			_item.put("st_reason_code",   at(_reasonCode, i));
			_item.put("st_reason_remark", at(_reasonRemark, i));
			_item.put("st_alt_code",      at(_altCode, i));
			_items.add(_item);
		}

		Map<String,Object> _param = new HashMap<String,Object>();
		_param.put("st_catlg_id", _catlgId);
		_param.put("st_user_id",  _userId);

		// 같은 상품에 아직 처리되지 않은 요청이 있으면 막는다 - 승인 순서가 꼬인다
		if (masterMdCmCmsItemChangeReqService.getOpenReqCount(_param) > 0) {
			_response.put("Message", "이 상품정보코드에 처리 대기중인 수정요청이 이미 있습니다.");
			return _response;
		}

		try {
			String _reqNo = masterMdCmCmsItemChangeReqService.saveChangeReq(_param, _items);
			mp.put("Code", 1);
			_response.put("Message", "수정요청이 등록되었습니다. (요청번호 " + _reqNo + ")");
		} catch (RuntimeException e) {
			logger.error("수정요청 등록 실패 : ", e);
			_response.put("Message", CommonUtil.nvl(e.getMessage(), "수정요청 등록에 실패하였습니다."));
		}
		return _response;
	}

	/**
	 * 엑셀 일괄수정 결과의 [확인] — 정상 건 전체를 수정요청으로 등록한다.
	 *
	 * 상품 1건 = 요청 1건이라 행 수만큼 요청번호가 채번된다.
	 * ★ 파라미터를 항목마다 펼치면 1,000행에서 파라미터 수 상한(톰캣 기본 10,000)에 걸린다
	 *   → 항목 배열을 **JSON 문자열 하나**(st_items)로 받는다.
	 * ★ 한 건이 실패해도 나머지는 계속 등록한다 - 어느 상품이 왜 빠졌는지 메시지로 돌려준다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemChangeReqBulk.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveChangeReqBulk(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code", 0);
		_response.put("Result", mp);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _userId = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId());
		if ("".equals(_userId)) {
			_response.put("Message", "로그인 정보가 없습니다. 다시 로그인해 주세요.");
			return _response;
		}

		Object _parsed = JSONValue.parse(CommonUtil.nvl((String) pMap.get("st_items")));
		if (!(_parsed instanceof JSONArray) || ((JSONArray) _parsed).isEmpty()) {
			_response.put("Message", "등록할 내역이 없습니다.");
			return _response;
		}
		JSONArray _items = (JSONArray) _parsed;

		// 상품정보코드 단위로 묶는다. 화면이 상품 순서대로 보내지만, 순서를 믿지 않고 코드로 모은다
		List<String> _codes = new ArrayList<String>();
		Map<String, List<Map<String,String>>> _byCode = new HashMap<String, List<Map<String,String>>>();

		for (int i = 0; i < _items.size(); i++) {
			Object _row = _items.get(i);
			if (!(_row instanceof JSONObject)) { continue; }
			JSONObject _o = (JSONObject) _row;

			String _code = jsonStr(_o, "c");
			String _col  = jsonStr(_o, "k");
			if ("".equals(_code) || "".equals(_col)) { continue; }

			Map<String,String> _item = new HashMap<String,String>();
			_item.put("st_job_column",    _col);
			_item.put("st_old_data",      jsonStr(_o, "o"));
			_item.put("st_new_data",      jsonStr(_o, "n"));
			_item.put("st_reason_code",   "");
			_item.put("st_reason_remark", jsonStr(_o, "r"));
			_item.put("st_alt_code",      jsonStr(_o, "a"));

			if (!_byCode.containsKey(_code)) {
				_byCode.put(_code, new ArrayList<Map<String,String>>());
				_codes.add(_code);
			}
			List<Map<String,String>> _list = _byCode.get(_code);
			if (_list.size() < MAX_CHANGE_ITEMS) { _list.add(_item); }
		}

		if (_codes.isEmpty()) {
			_response.put("Message", "등록할 내역이 없습니다.");
			return _response;
		}

		int _done = 0;
		int _skipped = 0;
		StringBuilder _fail = new StringBuilder();

		for (int i = 0; i < _codes.size(); i++) {
			String _code = _codes.get(i);

			Map<String,Object> _param = new HashMap<String,Object>();
			_param.put("st_catlg_id", _code);
			_param.put("st_user_id",  _userId);

			// 같은 상품에 처리 대기중인 요청이 있으면 건너뛴다(단건 경로와 같은 규칙)
			if (masterMdCmCmsItemChangeReqService.getOpenReqCount(_param) > 0) {
				_skipped++;
				continue;
			}

			try {
				masterMdCmCmsItemChangeReqService.saveChangeReqFromExcel(_param, _byCode.get(_code));
				_done++;
			} catch (RuntimeException e) {
				logger.error("일괄 수정요청 등록 실패 (상품정보코드 {}) : ", _code, e);
				if (_fail.length() > 0) { _fail.append("\n"); }
				_fail.append(_code).append(" : ").append(CommonUtil.nvl(e.getMessage(), "등록 실패"));
			}
		}

		mp.put("Code", (_done > 0) ? 1 : 0);

		StringBuilder _msg = new StringBuilder();
		if (_done > 0) { _msg.append(_done).append("건의 수정요청이 등록되었습니다."); }
		if (_skipped > 0) {
			if (_msg.length() > 0) { _msg.append("\n"); }
			_msg.append(_skipped).append("건은 처리 대기중인 요청이 이미 있어 건너뛰었습니다.");
		}
		if (_fail.length() > 0) {
			if (_msg.length() > 0) { _msg.append("\n"); }
			_msg.append("등록하지 못한 건\n").append(_fail);
		}
		if (_msg.length() == 0) { _msg.append("등록된 건이 없습니다."); }

		_response.put("Message", _msg.toString());
		return _response;
	}

	private String jsonStr(JSONObject o, String key) {
		Object _v = o.get(key);
		return (_v == null) ? "" : CommonUtil.nvl(("" + _v).trim());
	}

	/**
	 * 요청취소. 진행상태가 '요청'인 본인 건만 취소된다(조건은 매퍼가 건다).
	 * 그리드는 변경항목 단위 행이라 같은 요청번호가 여러 줄 체크될 수 있다 - 중복을 걷어내고 돈다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemChangeReqCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancelChangeReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code", 0);
		_response.put("Result", mp);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _userId = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId());
		if ("".equals(_userId)) {
			_response.put("Message", "로그인 정보가 없습니다. 다시 로그인해 주세요.");
			return _response;
		}

		List<String> _reqNos = valueList(pMap, "st_req_no");
		List<String> _target = new ArrayList<String>();
		for (int i = 0; i < _reqNos.size(); i++) {
			String _no = CommonUtil.nvl(_reqNos.get(i)).trim();
			if (!"".equals(_no) && !_target.contains(_no)) { _target.add(_no); }
		}
		if (_target.isEmpty()) {
			_response.put("Message", "취소할 요청을 선택해 주세요.");
			return _response;
		}

		int _canceled = 0;
		try {
			for (int i = 0; i < _target.size(); i++) {
				Map<String,Object> _param = new HashMap<String,Object>();
				_param.put("st_req_no",  _target.get(i));
				_param.put("st_user_id", _userId);
				_canceled += masterMdCmCmsItemChangeReqService.cancelChangeReq(_param);
			}
		} catch (RuntimeException e) {
			logger.error("요청취소 실패 : ", e);
			_response.put("Message", "요청취소에 실패하였습니다.");
			return _response;
		}

		mp.put("Code", 1);
		if (_canceled == 0) {
			// 승인·반려된 건이거나 남의 요청이면 여기로 온다
			_response.put("Message", "취소된 건이 없습니다. 진행상태가 [요청]인 본인 요청만 취소할 수 있습니다.");
		} else if (_canceled < _target.size()) {
			_response.put("Message", _target.size() + "건 중 " + _canceled + "건만 취소되었습니다. 나머지는 이미 처리된 요청입니다.");
		} else {
			_response.put("Message", _canceled + "건이 취소되었습니다.");
		}
		return _response;
	}

	// ======================= DB관리파트 승인화면 =======================

	/* 승인 대기열 목록.
	 * 현황 화면과 매퍼가 다르다(masterMdCmCmsItemChangeReq-sql.xml) -
	 * 미처리(REQ) 한정은 그 SQL 이 직접 걸고, 여기서 상태를 넘기지 않는다(미처리 대기열). */
	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemChangeReqList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchReqList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemChangeReqService.getReqList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	// 엑셀다운로드 (조회 내역 전체)
	@RequestMapping(value = "/mdam/getMasterMdCmCmsItemChangeReqExcelList.do", method = {RequestMethod.GET, RequestMethod.POST})
	public void excelReqList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("엑셀다운로드 요청 파라미터 : {}", pMap);

		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCmCmsItemChangeReqService.getReqList(pMap);

		IBSheetUtil.excelOut(req, res, _data);
	}

	/**
	 * 비교 팝업 (요청번호 클릭).
	 * 좌=기존 / 우=변경 두 벌을 여기서 만들어 넘긴다 - JSP 는 받은 대로 그리기만 한다.
	 *  - 바탕 = CMSCATLG 현재 상세(카테고리·상세분류·일회성구분·구매담당자처럼 변경 대상이 아닌 문맥값 때문)
	 *  - 좌 = 그 바탕에 요청 시점 스냅샷 + 변경항목의 OLD_DATA 를 덮음
	 *  - 우 = 좌에 NEW_DATA 를 덮음
	 * 변경된 항목만 빨간 글자로 칠하는 판정은 changed 집합(JOB_COLUMN)으로 넘긴다.
	 */
	@RequestMapping(value = "/mdcm/showMasterMdCmCmsItemChangeReqComparePop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showComparePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("비교 팝업 요청 파라미터 : {}", pMap);

		Map<String,String> _header = masterMdCmCmsItemChangeReqService.getHeader(pMap);
		if (_header == null) { _header = new HashMap<String,String>(); }

		List<Map<String,String>> _items = masterMdCmCmsItemChangeReqService.getDtList(pMap);

		// 상세 조회는 CMS_CATLG_ID 를 st_msds_no 파라미터로 받는다(기존 매퍼 관례 - 이름과 실제 값이 다르다)
		Map<String,Object> _detailParam = new HashMap<String,Object>();
		_detailParam.put("st_msds_no", CommonUtil.nvl(_header.get("CMS_CATLG_ID")));

		Map<String,String> _base = masterMdCmCmsItemService.getDetail(_detailParam);
		if (_base == null) { _base = new HashMap<String,String>(); }

		List<Map<String,String>> _attrList = masterMdCmCmsItemService.getDetailAttrList(_detailParam);
		if (_attrList == null) { _attrList = new ArrayList<Map<String,String>>(); }

		Map<String,String> _before = new HashMap<String,String>(_base);
		Map<String,String> _after  = new HashMap<String,String>(_base);

		// ① 요청 시점 스냅샷으로 좌·우의 바탕을 되돌린다(승인 후에 열어도 요청 당시 화면이 보이게)
		applySnapshot(_before, _header);
		applySnapshot(_after,  _header);

		// ② 변경항목을 덮는다
		List<String> _changed = new ArrayList<String>();
		for (int i = 0; i < _items.size(); i++) {
			Map<String,String> _it = _items.get(i);
			String _col = CommonUtil.nvl(_it.get("JOB_COLUMN"));
			_changed.add(_col);
			putByJobColumn(_before, _col, CommonUtil.nvl(_it.get("OLD_DATA")), CommonUtil.nvl(_it.get("OLD_TEXT")));
			putByJobColumn(_after,  _col, CommonUtil.nvl(_it.get("NEW_DATA")), CommonUtil.nvl(_it.get("NEW_TEXT")));
		}

		pModel.addAttribute("header",   _header);
		pModel.addAttribute("items",    _items);
		pModel.addAttribute("before",   _before);
		pModel.addAttribute("after",    _after);
		pModel.addAttribute("attrList", _attrList);
		pModel.addAttribute("changed",  _changed);
		return "common/popup/mdcm/masterMdCmCmsItemChangeReqComparePop";
	}

	// 요청 시점 스냅샷(헤더 7열)을 상세 맵 위에 덮는다. 값이 비어 있으면 건드리지 않는다
	private void applySnapshot(Map<String,String> target, Map<String,String> header) {
		copyIfPresent(target, "STATUS",           header, "STATUS");
		copyIfPresent(target, "STATUS_NM",        header, "STATUS_NM");
		copyIfPresent(target, "DESCRIPTION_LOC",  header, "DESCRIPTION_LOC");
		copyIfPresent(target, "MODEL_INFO",       header, "MODEL_INFO");
		copyIfPresent(target, "SPECIFICATION",    header, "SPECIFICATION");
		copyIfPresent(target, "MAKER_CODE",       header, "MAKER_CODE");
		copyIfPresent(target, "MAKER_NAME",       header, "MAKER_NAME");
		copyIfPresent(target, "ORIGIN_CODE",      header, "ORIGIN_CODE");
		copyIfPresent(target, "ORIGIN_CODE_NAME", header, "ORIGIN_CODE_NAME");
		copyIfPresent(target, "ORDER_MEASURE",    header, "ORDER_MEASURE");
	}

	private void copyIfPresent(Map<String,String> target, String targetKey, Map<String,String> src, String srcKey) {
		String _v = CommonUtil.nvl(src.get(srcKey));
		if (!"".equals(_v)) { target.put(targetKey, _v); }
	}

	/* 변경항목 1건을 상세 맵에 반영.
	 * 코드 컬럼은 코드와 표시명 두 칸을 같이 갈아야 한다 - 한쪽만 바꾸면 화면에 옛 명칭이 남는다.
	 * 표시명은 조회 SQL 이 이미 만들어 준 OLD_TEXT/NEW_TEXT 를 쓴다.
	 * ⚠ 제조사의 OLD_TEXT/NEW_TEXT 는 '명 (코드)' 형태라 팝업 표기에도 그대로 쓴다(목록과 같은 표기). */
	private void putByJobColumn(Map<String,String> target, String jobColumn, String code, String text) {
		if ("STATUS".equals(jobColumn)) {
			target.put("STATUS", code);
			target.put("STATUS_NM", text);
		} else if ("DESCRIPTION_LOC".equals(jobColumn)) {
			target.put("DESCRIPTION_LOC", code);
		} else if ("MODEL_INFO".equals(jobColumn)) {
			target.put("MODEL_INFO", code);
		} else if ("SPECIFICATION".equals(jobColumn)) {
			target.put("SPECIFICATION", code);
		} else if ("MAKER_CODE".equals(jobColumn)) {
			target.put("MAKER_CODE", code);
			target.put("MAKER_NAME", text);
		} else if ("ORIGIN_CODE".equals(jobColumn)) {
			target.put("ORIGIN_CODE", code);
			target.put("ORIGIN_CODE_NAME", text);
		} else if ("ORDER_MEASURE".equals(jobColumn)) {
			target.put("ORDER_MEASURE", code);
		} else if ("ITEM_GUBUN".equals(jobColumn)) {
			target.put("ITEM_GUBUN", code);
			target.put("ITEM_GUBUN_NM", text);
		} else if ("TR_HANDLE_TYPE".equals(jobColumn)) {
			target.put("TR_HANDLE_TYPE", code);
			target.put("TR_HANDLE_NM", text);
		}
	}

	/**
	 * 승인. 체크된 요청번호 단위로 처리한다.
	 * 한 요청이라도 반영에 실패하면 그 요청만 롤백되고 메시지에 남는다
	 * 일괄 승인 도중 하나 때문에 전부 되돌리지 않는다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemChangeReqApprove.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approveChangeReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		return processChangeReq(req, pMap, true);
	}

	/**
	 * 반려. 반려사유는 팝업에서 한 번 입력받아 **체크 건 전체에 같은 값**으로 들어간다.
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmCmsItemChangeReqReject.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectChangeReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		return processChangeReq(req, pMap, false);
	}

	// 승인·반려 공통 처리
	private Map<String, Object> processChangeReq(HttpServletRequest req, MultiValueMap<String, String> pMap, boolean isApprove) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code", 0);
		_response.put("Result", mp);

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _userId = (_sessionInfo == null) ? "" : CommonUtil.nvl(_sessionInfo.getUserId());
		if ("".equals(_userId)) {
			_response.put("Message", "로그인 정보가 없습니다. 다시 로그인해 주세요.");
			return _response;
		}
		// 화면에서 버튼을 감추는 것과 별개로 서버에서도 다시 확인한다
		if (!isDbPartUser(_userId)) {
			_response.put("Message", "DB관리파트 담당자만 승인·반려할 수 있습니다.");
			return _response;
		}

		String _rejectReason = "";
		if (!isApprove) {
			_rejectReason = firstValue(pMap, "st_reject_reason").trim();
			if ("".equals(_rejectReason)) {
				_response.put("Message", "반려사유를 입력해 주세요.");
				return _response;
			}
		}

		List<String> _reqNos = valueList(pMap, "st_req_no");
		List<String> _target = new ArrayList<String>();
		for (int i = 0; i < _reqNos.size(); i++) {
			String _no = CommonUtil.nvl(_reqNos.get(i)).trim();
			if (!"".equals(_no) && !_target.contains(_no)) { _target.add(_no); }
		}
		if (_target.isEmpty()) {
			_response.put("Message", (isApprove ? "승인할" : "반려할") + " 요청을 선택해 주세요.");
			return _response;
		}

		int _done = 0;
		int _skipped = 0;
		StringBuilder _fail = new StringBuilder();

		for (int i = 0; i < _target.size(); i++) {
			Map<String,Object> _param = new HashMap<String,Object>();
			_param.put("st_req_no",  _target.get(i));
			_param.put("st_user_id", _userId);
			if (!isApprove) { _param.put("st_reject_reason", _rejectReason); }

			try {
				int _moved = isApprove ? masterMdCmCmsItemChangeReqService.approveChangeReq(_param)
				                       : masterMdCmCmsItemChangeReqService.rejectChangeReq(_param);
				if (_moved > 0) { _done++; } else { _skipped++; }
			} catch (RuntimeException e) {
				logger.error("수정요청 처리 실패 (요청번호 {}) : ", _target.get(i), e);
				if (_fail.length() > 0) { _fail.append("\n"); }
				_fail.append(_target.get(i)).append(" : ").append(CommonUtil.nvl(e.getMessage(), "처리 실패"));
			}
		}

		mp.put("Code", (_done > 0) ? 1 : 0);

		StringBuilder _msg = new StringBuilder();
		if (_done > 0) { _msg.append(_done).append("건이 ").append(isApprove ? "승인" : "반려").append("되었습니다."); }
		if (_skipped > 0) {
			if (_msg.length() > 0) { _msg.append("\n"); }
			_msg.append(_skipped).append("건은 이미 처리된 요청이라 건너뛰었습니다.");
		}
		if (_fail.length() > 0) {
			if (_msg.length() > 0) { _msg.append("\n"); }
			_msg.append("처리하지 못한 건\n").append(_fail);
		}
		if (_msg.length() == 0) { _msg.append("처리된 건이 없습니다."); }

		_response.put("Message", _msg.toString());
		return _response;
	}

	/* DB관리파트 여부.
	 * ⚠ TEMP_DB_PART_USER 예외는 임시다 - CDBM 코드가 적재되면 뺀다.
	 *   상품정보 목록·상세팝업의 같은 성격 예외와 함께 정리할 것. */
	private boolean isDbPartUser(String userId) {
		if ("".equals(CommonUtil.nvl(userId))) { return false; }
		if (TEMP_DB_PART_USER.equals(userId)) { return true; }
		return CommonUtil.getCode3CheckReturn(DB_PART_CODE_TYPE, userId, OPER_BUYER);
	}

	// ---- MultiValueMap 보조 ---------------------------------------------------

	private String firstValue(MultiValueMap<String, String> pMap, String key) {
		List<String> _values = pMap.get(key);
		if (_values == null || _values.isEmpty()) { return ""; }
		return CommonUtil.nvl(_values.get(0));
	}

	private List<String> valueList(MultiValueMap<String, String> pMap, String key) {
		List<String> _values = pMap.get(key);
		return (_values == null) ? new ArrayList<String>() : _values;
	}

	// 병렬 파라미터는 빈 값이 빠진 채로 올 수 있다 - 길이가 모자라면 공백으로 채운다
	private String at(List<String> list, int idx) {
		if (list == null || idx >= list.size()) { return ""; }
		return CommonUtil.nvl(list.get(idx));
	}
}
