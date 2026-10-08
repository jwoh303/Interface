package com.koreab2b.mro.buyer.mdcm.controller;

import java.io.OutputStream;
import java.util.HashMap;
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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmPopularGoodsSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmPopularGoodsSearchController")
public class BuyerMdCmPopularGoodsSearchController {
  
	@Autowired
	private BuyerMdCmPopularGoodsSearchService buyerMdCmPopularGoodsSearchService;
	
	// 조회 PG_06_B_003_00
	@RequestMapping(value = "/mdcm/getBuyerMdCmPopularGoodsSearchList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmPopularGoodsSearchList(ModelMap pModel ,HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"") );
		pMap.put("st_sort_change", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmPopularGoodsSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmPopularGoodsSearch";
	}
	
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니,D:,R:나의상품)
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmPopularGoods.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmPopularGoods(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMdCmPopularGoodsSearchService.saveBuyerMdCmPopularGoods(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 저장
	 *  desc DOOSCART
 		카테고리 DOOSCART  업데이트
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmFolderCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmFolderCode(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMdCmPopularGoodsSearchService.saveBuyerMdCmFolderCode(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 저장
	 *  desc DOOSCART
 		카테고리 ICOMUSCA  업데이트
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmFolderName.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmFolderName(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = buyerMdCmPopularGoodsSearchService.saveBuyerMdCmFolderName(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * 조회
	 *  
 		삭제단종품 검색
	 * 
	 */
	@RequestMapping(value = "/mdcm/getBuyerMdCmDeletePunchOutSearchList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmDeletePunchOutSearchList(ModelMap pModel ,HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("st_sort_flag", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmPopularGoodsSearchService.getDeleteList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmDeletePunchOutSearch";
	}
	/**
	 * 조회
	 *  
 		삭제단종품 EXCEL 다운
	 * 
	 */
	@RequestMapping(value = "/mdcm/excelBuyerMdCmDeletePunchOutSearchList.do", method = RequestMethod.POST)
	public void excelBuyerMdCmDeletePunchOutSearchList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
 
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMdCmPopularGoodsSearchService.getDeleteList(pMap);
	   
		String title = "";
		String headers = "";
		
		title = "KeP품목코드|두산품목코드|품명|규격|원산지|제조사|협력사|단가|상태|";	
		headers = "BUYER_ITEM_NO|DOOSAN_BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|ORIGIN_TEXT|MAKER_NAME|AGENT_NAME|UNIT_PRICE|PRODUCT_CLOSE_FLAG|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "삭제단종품.xls");	
		
	}
	 
	// 그린상품조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmGreenPunchOutSearchList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmGreenPunchOutSearchList(ModelMap pModel ,HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"") );
		pMap.put("st_sort_change", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmPopularGoodsSearchService.getGreenList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmGreenPunchOutSearchList";
	}
	 
	// 주단구매상품
	@RequestMapping(value = "/mdcm/getBuyerMdCmProjectPunchOutSearchList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmProjectPunchOutSearchList(ModelMap pModel ,HttpServletRequest req, @RequestParam Map<String, String> pMap) {		
		

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("st_buyer_item_no", CommonUtil.onvl(pMap.get("st_buyer_item_no") ,"") );
		pMap.put("st_description", CommonUtil.onvl(pMap.get("st_description") ,"") );
		pMap.put("st_specification", CommonUtil.onvl(pMap.get("st_specification") ,"") );
		pMap.put("st_maker_name", CommonUtil.onvl(pMap.get("st_maker_name") ,"") );
		pMap.put("st_sort_gubun", CommonUtil.onvl(pMap.get("st_sort_gubun") ,"") );
		pMap.put("st_sort_change", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 

		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmPopularGoodsSearchService.getProjectList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmProjectPunchOutSearchList";
	}
}
