package com.koreab2b.mro.buyer.mdam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmUserRegRequestReceiptService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmUserRegRequestReceiptController")
public class BuyerMdAmUserRegRequestReceiptController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmUserRegRequestReceiptController.class);

	@Autowired
	private BuyerMdAmUserRegRequestReceiptService buyerMdAmUserRegRequestReceiptService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmUserRegRequestReceiptList.do", method = RequestMethod.POST)
	public String getBuyerMdAmUserRegRequestReceiptList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdam/getBuyerMdAmUserRegRequestReceiptList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		
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
		
		List<Map<String, String>> _data = buyerMdAmUserRegRequestReceiptService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));

		// 리뉴얼 모드 분기: 통합 _v2 화면으로 렌더 + 탭 데이터 전달
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion) && _sessionInfo != null) {
			String menuId = pMap.get("menuId");
			List<Map<String,String>> _tabData = CommonUtil.getMenuTabInfo_v2(menuId, _sessionInfo.getUserId());
			pModel.addAttribute("tab_data", _tabData);
			return "buyer/mdam/buyerMdAmUserSearchList_v2";
		}
		return "buyer/mdam/buyerMdAmUserRegRequestReceiptList";
	}

	// IBSheet AJAX 데이터 (사용자관리 _v2 — PENDING/REJECTED 탭)
	@RequestMapping(value = "/mdam/getBuyerMdAmUserRegRequestReceiptList_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmUserRegRequestReceiptList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) throws Exception {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("st_user_id",         _sessionInfo.getUserId());
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			boolean tgcm = CommonUtil.getCode3CheckReturn("TGCM", _sessionInfo.getUserId(), _sessionInfo.getComCode());
			if (pMap.get("st_group_mng_flag") == null || "".equals(CommonUtil.nvl((String) pMap.get("st_group_mng_flag")))) {
				pMap.put("st_group_mng_flag", tgcm ? "Y" : "N");
			}
		}
		pMap = IBSheetUtil.removeSlash(pMap);
		pMap.put("paging", "0");
		// 탭별 SQL STATUS 필터 (PENDING='S' / REJECTED='D')
		String tabFilter = CommonUtil.nvl((String) pMap.get("st_tab"));
		if ("REJECTED".equals(tabFilter)) {
			pMap.put("st_target_status", "D");
		} else {
			pMap.put("st_target_status", "S");
		}

		Map<String, String> p = new HashMap<String, String>();
		for (Map.Entry<String, Object> e : pMap.entrySet()) {
			p.put(e.getKey(), e.getValue() == null ? "" : String.valueOf(e.getValue()));
		}
		List<Map<String, String>> _data = buyerMdAmUserRegRequestReceiptService.getList(p);

		// REG_REQ SQL 은 STATUS_TEXT 디코드가 없고 raw STATUS(S/C/D) 만 반환 → 탭별 라벨 부여.
		String tab = CommonUtil.nvl((String) pMap.get("st_tab"));
		if (_data != null) {
			for (Map<String, String> row : _data) {
				row.put("USER_ID_RAW",   CommonUtil.nvl(row.get("USER_ID")));
				row.put("USER_ID",       CommonUtil.nameMasking(CommonUtil.nvl(row.get("USER_ID"))));
				row.put("USER_NAME_LOC", CommonUtil.nameMasking(CommonUtil.nvl(row.get("USER_NAME_LOC"))));
				row.put("PHONE_NUMBER",  CommonUtil.phoneMasking(CommonUtil.nvl(row.get("PHONE_NUMBER"))));
				row.put("EMAIL",         CommonUtil.emailMasking(CommonUtil.nvl(row.get("EMAIL"))));
				row.put("CONFIRM_USER_NAME_RAW", CommonUtil.nvl(row.get("CONFIRM_USER_NAME")));
				row.put("CONFIRM_USER_NAME",  CommonUtil.nameMasking(CommonUtil.nvl(row.get("CONFIRM_USER_NAME"))));

				if ("PENDING".equals(tab)) {
					row.put("STATUS_TEXT", "승인대기");
				} else if ("REJECTED".equals(tab)) {
					row.put("STATUS_TEXT", "승인거절");
				}
			}
		}
		return IBSheetUtil.addResut(req, _data, pMap);
	}

	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmUserRegRequestReceiptList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmUserRegRequestReceiptList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdam/saveBuyerMdAmUserRegRequestReceiptList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		String flag = buyerMdAmUserRegRequestReceiptService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}

}
