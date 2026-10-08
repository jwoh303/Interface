package com.koreab2b.mro.master.mdcm.dao;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMdCmCmsItemChangeReqDao")
@Transactional
public class MasterMdCmCmsItemChangeReqDaoImpl implements MasterMdCmCmsItemChangeReqDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCmsItemChangeReqDaoImpl.class);

	/* 상품상태 [미사용] (CMSCATLG.STATUS) */
	private static final String ITEM_STATUS_UNUSE = "D";

	/* 구매정보 공급상태 [불가] (CMSPRICE.STATUS).
	 * ⚠ 값 체계가 확정 전이라 ICOMCQDT(미러 원본)·CMSCATLG 관례를 따라 'D' 로 둔다.
	 *   값이 정해지면 여기 한 곳만 바꾸면 된다. */
	private static final String BUYINFO_STATUS_UNAVAIL = "D";

	/* 연쇄 불가 처리 전용 사유 (ICOMCOD1 M185, TEXT3='SYS' 라 화면 드롭다운에는 안 나온다).
	 * 상품정보 사유(M182)를 복사하면 안 된다 - 코드 어휘가 어긋나고(단종 DIS↔DISC),
	 * 사람이 고른 사유와 시스템이 내린 것이 목록에서 구분되지 않는다. */
	private static final String BUYINFO_REASON_ITEM_UNUSE = "ITMOUT";

	/* ★ 승인 시 CMSCATLG 에 반영해도 되는 컬럼.
	 * 반영 UPDATE 는 컬럼명을 바인드할 수 없어 SQL 에 그대로 박는다(${st_job_column}) —
	 * 이 집합을 통과한 값만 쓴다. 늘릴 때는 그 컬럼이 VARCHAR2 인지 함께 확인할 것
	 * (NUMBER 면 TO_CHAR 함정에 걸린다).
	 *
	 * ITEM_GUBUN 은 M118 에 'N'(비표준품) 코드행을 적재해 2026-09-07 화이트리스트에 넣었다. */
	private static final Set<String> APPLY_COLUMNS = Collections.unmodifiableSet(new HashSet<String>(Arrays.asList(
		  "STATUS"
		, "DESCRIPTION_LOC"
		, "MODEL_INFO"
		, "SPECIFICATION"
		, "MAKER_CODE"
		, "ORIGIN_CODE"
		, "ORDER_MEASURE"
		, "TR_HANDLE_TYPE"
		, "ITEM_GUBUN"
	)));

	/* 요청번호 채번 (2026-09-07 사용자 결정).
	 * 시퀀스가 아니라 이 프로젝트의 문서번호 관례 - 채번 테이블 `ICOMSQMT` 를 쓴다.
	 * 번호 = DOC_TYPE + 연도 뒤 2자리 + LPAD(CUR_NO,6) → `CR26000001` (문자 2 + 숫자 8 = 10자리).
	 * ⚠ DOC_TYPE 은 VARCHAR2(4) 이고 REQ_NO 는 VARCHAR2(10) 이라 접두는 2자를 넘길 수 없다.
	 * ⚠ 채번은 SELECT 후 UPDATE 라 동시 요청에 같은 번호가 나올 수 있다(PR/PX/SR 도 같은 방식). */
	private static final String DOC_TYPE  = "CR";
	private static final String OPER_COMP = "KRKORE0001";	// 표준DB 는 운영사 전용 화면

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 채번 공통 구현 재사용 - ICOMSQMT 행이 없으면 이 안에서 만들고 …000001 부터 준다
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;

	/* 상품정보 수정요청 현황 목록 (요청자 화면).
	 * 매퍼는 masterMdCmCmsItemChangeReqStatus-sql.xml - DB관리파트 목록과 SQL 을 공유하지 않는다. */
	public List<Map<String,String>> selectStatusList(Map<String,Object> param) {
		convertMultiCond(param);
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemChangeReqStatusList", param);
	}

	/* 승인 대기열 목록 (DB관리파트 화면).
	 * 미처리(REQ) 한정은 매퍼가 건다 - 파라미터로 상태를 받지 않는다. */
	public List<Map<String,String>> selectReqList(Map<String,Object> param) {
		convertMultiCond(param);
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemChangeReqList", param);
	}

	// 대량입력 팝업이 넘긴 '@' 구분 문자열을 IN 절용 List 로 변환한다
	private void convertMultiCond(Map<String,Object> param) {
		param.put("st_req_no_multi",   CommonUtil.getStringArrary((String) param.get("st_req_no_multi"),   "@"));
		param.put("st_cmscatlg_multi", CommonUtil.getStringArrary((String) param.get("st_cmscatlg_multi"), "@"));
	}

	// 처리 대기중(REQ)인 요청 건수
	public int selectOpenReqCount(Map<String,Object> param) {
		Integer _cnt = (Integer) sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsItemChangeReqOpenCount", param);
		return (_cnt == null) ? 0 : _cnt.intValue();
	}

	/* 요청 등록.
	 * 헤더의 스냅샷 7열은 매퍼가 CMSCATLG 에서 직접 복사한다 - 화면이 보낸 값을 믿지 않는다.
	 * 변경항목은 화면이 준 순서대로 REQ_SEQ 를 1부터 매긴다(그리드 정렬축). */
	public String insertChangeReq(Map<String,Object> param, List<Map<String,String>> items) {
		String _reqNo = "";

		try {
			_reqNo = buyerMpSoOrderInfoDao.getOrderNo(OPER_COMP, DOC_TYPE);
			param.put("st_req_no", _reqNo);

			int _cnt = sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsItemChangeReq", param);
			// CMSCATLG 에 없는 상품정보코드면 INSERT ... SELECT 가 0건이 된다 - 상세를 남기면 고아 행이 된다
			if (_cnt == 0) {
				throw new RuntimeException("존재하지 않는 상품정보코드입니다.");
			}

			for (int i = 0; i < items.size(); i++) {
				Map<String,Object> _dt = new HashMap<String,Object>();
				_dt.put("st_req_no",       _reqNo);
				_dt.put("st_req_seq",      Integer.valueOf(i + 1));
				_dt.put("st_job_column",   items.get(i).get("st_job_column"));
				_dt.put("st_old_data",     items.get(i).get("st_old_data"));
				_dt.put("st_new_data",     items.get(i).get("st_new_data"));
				_dt.put("st_reason_code",  items.get(i).get("st_reason_code"));
				_dt.put("st_reason_remark",items.get(i).get("st_reason_remark"));
				_dt.put("st_alt_code",     items.get(i).get("st_alt_code"));

				sqlSessionTemplate.update("master.mdcm.insertMasterMdCmCmsItemChangeReqDt", _dt);
			}
		} catch (RuntimeException e) {
			LOGGER.error("SQL ERROR : ", e);
			throw e;
		} catch (Exception e) {
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("수정요청 등록에 실패하였습니다.");
		}
		return _reqNo;
	}

	/* 엑셀 일괄수정 경로의 요청 등록.
	 * 결과 그리드는 사람이 읽는 **명칭**을 들고 있어(상품상태·상품구분·TR·상품상태 변경사유)
	 * 그대로 넣으면 승인 때 CMSCATLG 에 명칭이 박힌다 - 여기서 코드로 되돌린 뒤 공통 등록으로 넘긴다.
	 * 제조사·원산지는 양식에 코드 열이 따로 있어 화면이 이미 코드를 보낸다. */
	public String insertChangeReqFromExcel(Map<String,Object> param, List<Map<String,String>> items) {
		for (int i = 0; i < items.size(); i++) {
			Map<String,String> _it = items.get(i);
			String _col = CommonUtil.nvl(_it.get("st_job_column"));

			if ("STATUS".equals(_col)) {
				_it.put("st_old_data", statusCode(_it.get("st_old_data")));
				_it.put("st_new_data", statusCode(_it.get("st_new_data")));
				// 상품상태 변경사유는 코드로 저장한다(M182). 못 찾으면 텍스트 자리에 그대로 남긴다
				String _reason = CommonUtil.nvl(_it.get("st_reason_remark"));
				String _code   = codeByText("M182", _reason);
				if (!"".equals(_code)) {
					_it.put("st_reason_code",   _code);
					_it.put("st_reason_remark", "");
				}
			} else if ("ITEM_GUBUN".equals(_col)) {
				_it.put("st_old_data", gubunCode(_it.get("st_old_data")));
				_it.put("st_new_data", gubunCode(_it.get("st_new_data")));
			} else if ("TR_HANDLE_TYPE".equals(_col)) {
				_it.put("st_old_data", trCode(_it.get("st_old_data")));
				_it.put("st_new_data", trCode(_it.get("st_new_data")));
			}
		}
		return insertChangeReq(param, items);
	}

	// 상품상태 : 화면 규칙 그대로 (상세팝업 curStatusCode 와 같은 축)
	private String statusCode(String text) {
		String _v = CommonUtil.nvl(text).trim();
		if ("".equals(_v)) { return ""; }
		return "미사용".equals(_v) ? "D" : "C";
	}

	/* 상품구분 : 화면이 M118 4값(M/G/S/A)을 G/N 2값으로 접어 쓴다.
	 * 'N'(비표준품)은 2026-09-07 M118 에 코드행을 적재해 실코드가 됐다 - 그래서 ITEM_GUBUN 이 화이트리스트에 있다. */
	private String gubunCode(String text) {
		String _v = CommonUtil.nvl(text).trim();
		if ("".equals(_v)) { return ""; }
		return "표준품".equals(_v) ? "G" : "N";
	}

	// TR취급가능여부 : 코드표(M181)에서 명칭으로 찾는다. 못 찾으면 빈값(요청에 안 들어간다)
	private String trCode(String text) {
		return codeByText("M181", text);
	}

	private String codeByText(String type, String text) {
		String _v = CommonUtil.nvl(text).trim();
		if ("".equals(_v)) { return ""; }
		Map<String,Object> _p = new HashMap<String,Object>();
		_p.put("st_code_type", type);
		_p.put("st_code_text", _v);
		String _code = (String) sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsItemChangeReqCodeByText", _p);
		return CommonUtil.nvl(_code);
	}

	// 요청취소 (진행상태 '요청'인 본인 건만 - 조건은 매퍼가 건다)
	public int updateChangeReqCancel(Map<String,Object> param) {
		return sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemChangeReqCancel", param);
	}

	// 비교 팝업 - 요청 헤더 1건
	public Map<String,String> selectHeader(Map<String,Object> param) {
		return sqlSessionTemplate.selectOne("master.mdcm.selectMasterMdCmCmsItemChangeReqHeader", param);
	}

	// 비교 팝업 / 승인 반영 - 변경항목 전체
	public List<Map<String,String>> selectDtList(Map<String,Object> param) {
		return sqlSessionTemplate.selectList("master.mdcm.selectMasterMdCmCmsItemChangeReqDtList", param);
	}

	/* 승인.
	 * 순서가 중요하다 - **헤더 상태를 먼저** 바꾼다. WHERE REQ_STATUS='REQ' 가 걸려 있어
	 * 이미 처리된 건이면 0건이 돌아오고, 그때는 CMSCATLG 를 건드리지 않는다(이중 승인 방지).
	 * 반영 UPDATE 는 SET 절에서 F_HST_CMSCATLG 를 타 이력까지 같이 남긴다. */
	public int approveChangeReq(Map<String,Object> param) {
		int _moved = sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemChangeReqApprove", param);
		if (_moved == 0) { return 0; }

		List<Map<String,String>> _items = selectDtList(param);
		String _userId = (String) param.get("st_user_id");

		for (int i = 0; i < _items.size(); i++) {
			Map<String,String> _it = _items.get(i);
			String _col = CommonUtil.nvl(_it.get("JOB_COLUMN"));

			// ★ 컬럼명은 바인드가 안 되고 SQL 에 그대로 박힌다 - 화이트리스트를 통과한 값만 쓴다
			if (!APPLY_COLUMNS.contains(_col)) {
				throw new RuntimeException("반영할 수 없는 변경항목입니다. (" + _col + ")");
			}

			Map<String,Object> _up = new HashMap<String,Object>();
			_up.put("st_job_column",   _col);
			_up.put("st_catlg_id",     _it.get("CMS_CATLG_ID"));
			_up.put("st_new_data",     _it.get("NEW_DATA"));
			_up.put("st_user_id",      _userId);
			_up.put("st_reason_code",  _it.get("CHANGE_REASON_CODE"));
			_up.put("st_reason_remark",_it.get("CHANGE_REASON_REMARK"));
			_up.put("st_alt_code",     _it.get("ALT_CATLG_ID"));

			sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemChangeReqApplyCatlg", _up);

			// 상품상태 변경만 본체에 사유·대체코드를 남긴다(목록 화면의 [미사용 변경사유]·[대체코드] 열 출처)
			if ("STATUS".equals(_col)) {
				sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemChangeReqApplyReason", _up);

				// ★ 미사용으로 내렸으면 그 상품에 달린 구매정보도 전부 [불가] 로 함께 내린다.
				if (ITEM_STATUS_UNUSE.equals(CommonUtil.nvl(_it.get("NEW_DATA")))) {
					Map<String,Object> _buy = new HashMap<String,Object>();
					_buy.put("st_catlg_id",      _it.get("CMS_CATLG_ID"));
					_buy.put("st_user_id",       _userId);
					_buy.put("st_new_status",    BUYINFO_STATUS_UNAVAIL);
					_buy.put("st_reason_code",   BUYINFO_REASON_ITEM_UNUSE);
					_buy.put("st_reason_remark", "");

					int _cnt = sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemChangeReqApplyBuyInfoUnuse", _buy);
					LOGGER.debug("상품정보 미사용 반영에 따라 구매정보 {} 건을 불가로 변경 : {}", _cnt, _it.get("CMS_CATLG_ID"));
				}
			}
		}
		return 1;
	}

	// 반려 (진행상태 '요청'인 건만 - 조건은 매퍼가 건다)
	public int rejectChangeReq(Map<String,Object> param) {
		return sqlSessionTemplate.update("master.mdcm.updateMasterMdCmCmsItemChangeReqReject", param);
	}
}
