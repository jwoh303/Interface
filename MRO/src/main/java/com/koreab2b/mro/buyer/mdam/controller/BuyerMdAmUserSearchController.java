package com.koreab2b.mro.buyer.mdam.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmUserSearchService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmUserSearchController")
public class BuyerMdAmUserSearchController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmUserSearchController.class);

	@Autowired
	private BuyerMdAmUserSearchService buyerMdAmUserSearchService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmUserSearchList.do", method = RequestMethod.POST)
	public String getBuyerMdAmUserSearchList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdam/getBuyerMdAmUserSearchList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		List<Map<String, String>> _data = buyerMdAmUserSearchService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		// 리뉴얼 모드 분기: 통합 _v2 화면으로 렌더 + 탭 데이터 전달
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String menuId = pMap.get("menuId");
			List<Map<String,String>> _tabData = CommonUtil.getMenuTabInfo_v2(menuId, _sessionInfo.getUserId());
			pModel.addAttribute("tab_data", _tabData);
			return "buyer/mdam/buyerMdAmUserSearchList_v2";
		}
		return "buyer/mdam/buyerMdAmUserSearchList";
	}

	// IBSheet AJAX 데이터 (사용자관리 _v2 — ALL/APPROVED 탭)
	@RequestMapping(value = "/mdam/getBuyerMdAmUserSearchList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmUserSearchList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) throws Exception {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("st_user_id",         _sessionInfo.getUserId());
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			/* 감사로그용 — v1(getBuyerMdAmUserSearchList)과 동일. 빠지면 KEPSITE_LOG 의 등록자·이름·IP 가 NULL 이 된다 */
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
			// TGCM(계열사 통합 관리) 권한 — JSP 와 동일 분기
			boolean tgcm = CommonUtil.getCode3CheckReturn("TGCM", _sessionInfo.getUserId(), _sessionInfo.getComCode());
			if (pMap.get("st_group_mng_flag") == null || "".equals(CommonUtil.nvl((String) pMap.get("st_group_mng_flag")))) {
				pMap.put("st_group_mng_flag", tgcm ? "Y" : "N");
			}
		} else {
			pMap.put("REG_ID", "");
			pMap.put("REG_IP", "");
		}
		pMap = IBSheetUtil.removeSlash(pMap);
		// jsppagestart 매크로용 paging 파라미터 — pagingMode="N" 이므로 전체 반환
		pMap.put("paging", "0");

		Map<String, String> p = new HashMap<String, String>();
		for (Map.Entry<String, Object> e : pMap.entrySet()) {
			p.put(e.getKey(), e.getValue() == null ? "" : String.valueOf(e.getValue()));
		}
		List<Map<String, String>> _data = buyerMdAmUserSearchService.getList(p);

		// 마스킹 — 기존 JSP 서버렌더 시점에 하던 작업을 응답 직전으로 이동.
		// 마스킹 전 원본 USER_ID 는 USER_ID_RAW 로 별도 보존(update 키로 사용).
		// STATUS_TEXT 는 탭별 라벨로 override (APPROVED → 승인완료, ALL → STATUS 'D' 면 '삭제' 아니면 '승인완료').
		String tab = CommonUtil.nvl((String) pMap.get("st_tab"));
		if (_data != null) {
			for (Map<String, String> row : _data) {
				row.put("USER_ID_RAW",   CommonUtil.nvl(row.get("USER_ID")));
				row.put("USER_ID",       CommonUtil.nameMasking(CommonUtil.nvl(row.get("USER_ID"))));
				row.put("USER_NAME_LOC", CommonUtil.nameMasking(CommonUtil.nvl(row.get("USER_NAME_LOC"))));
				row.put("PHONE_NUMBER",  CommonUtil.phoneMasking(CommonUtil.nvl(row.get("PHONE_NUMBER"))));
				row.put("EMAIL",         CommonUtil.emailMasking(CommonUtil.nvl(row.get("EMAIL"))));

				if ("APPROVED".equals(tab)) {
					row.put("STATUS_TEXT", "승인완료");
				} else if ("ALL".equals(tab)) {
					// STATUS='D' 는 '거절'과 '삭제' 모두 동일 코드를 사용 → REJECT_REASON 채움 여부로 구분
					String _status = CommonUtil.nvl(row.get("STATUS"));
					String _rejectReason = CommonUtil.nvl(row.get("REJECT_REASON"));
					if ("D".equals(_status)) {
						row.put("STATUS_TEXT", !"".equals(_rejectReason) ? "승인거절" : "삭제");
					} else {
						row.put("STATUS_TEXT", "승인완료");
					}
				}
			}
		}
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmUserSearchList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmUserSearch(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdam/saveBuyerMdAmUserSearchList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		/*로그관련 셋팅*/
		pMap.put("REG_ID", _sessionInfo.getUserId());
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		
		String flag = buyerMdAmUserSearchService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	// EXCEL 다운로드	
	@RequestMapping(value = "/mdam/excelBuyerMdAmUserSearchList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoOrderPunchOutProgressList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		List<Map<String, String>> _data = buyerMdAmUserSearchService.getList(pMap);  
		String title = "상태|고객사코드|고객사명|사용자ID|사용자명|부서코드|부서명|";
		String headers = "STATUS_TEXT|COM_CODE|COM_NAME_LOC|USER_ID|USER_NAME_LOC|DEPARTMENT|DEPT_NAME|";
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"사용자조회.xls");
	}

}
