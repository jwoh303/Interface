package com.koreab2b.mro.buyer.mpso.controller;

import java.io.OutputStream;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDeliveryPunchOutProgressService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoDeliveryPunchOutProgressController")
public class BuyerMpSoDeliveryPunchOutProgressController {
 

	@Autowired
	private BuyerMpSoDeliveryPunchOutProgressService buyerMpSoDeliveryPunchOutProgressService;
	
	// 납기도래품목현황 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoDeliveryCommingPunchOutList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoDeliveryCommingPunchOutList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no") ,"") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoDeliveryPunchOutProgressService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoDeliveryCommingPunchOutSearchList";
	}
	
	// 납기도래품목현황 엑셀다운로드
	@RequestMapping(value = "/mpso/excelBuyerMpSoDeliveryCommingPunchOutList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoDeliveryCommingPunchOutList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {

		
		pMap.put("st_com_code", CommonUtil.onvl(pMap.get("st_com_code") ,"") );
		pMap.put("st_user_id", CommonUtil.onvl(pMap.get("st_user_id") ,"") );
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no") ,"") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoDeliveryPunchOutProgressService.getList(pMap);
	   
		String title = "";
		String headers = "";
		
		title = "발주번호|요청번호|품목코드|품목명|규격|발주수량|납품수량|납기요청일|납품예정일|발주금액|납품금액|협력사|발주자|";	
		headers = "LEGACY_PO_NO|REF_PR_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|CD_QTY|RD_DATE|DS_DATE|ITEM_AMT|CD_AMT|AGENT_NAME|ADD_USER_NAME|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납기도래품목현황.xls");	
		
	}

	// 납기지연품목현황 조회
	@RequestMapping(value = "/mpso/getBuyerMpSoDeliveryDelayPunchOutList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoDeliveryDelayPunchOutList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no") ,"") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoDeliveryPunchOutProgressService.getDelayList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoDeliveryDelayPunchOutSearchList";
	}
	
	// 납기도래품목현황 엑셀다운로드
	@RequestMapping(value = "/mpso/excelBuyerMpSoDeliveryDelayPunchOutList.do", method = RequestMethod.POST)
	public void excelBuyerMpSoDeliveryDelayPunchOutList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {

		
		pMap.put("st_com_code", CommonUtil.onvl(pMap.get("st_com_code") ,"") );
		pMap.put("st_user_id", CommonUtil.onvl(pMap.get("st_user_id") ,"") );
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_legacy_po_no", CommonUtil.onvl(pMap.get("st_legacy_po_no") ,"") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMpSoDeliveryPunchOutProgressService.getDelayList(pMap);
	   
		String title = "";
		String headers = "";
		
		title = "발주번호|요청번호|품목코드|품목명|규격|발주수량|지연일수|납기요청일|발주일|발주단가|발주금액|협력사|발주자|";	
		headers = "LEGACY_PO_NO|REF_PR_NO|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ITEM_QTY|DELAY_DAY|RD_DATE|PO_CREATE_DATE|UNIT_PRICE|PO_SUM|AGENT_TEXT|PURCHASER_NAME|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "납기지연품목현황.xls");	
		
	}

}
