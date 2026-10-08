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

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmCartPunchoutSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmCartPunchoutSearchController")
public class BuyerMdCmCartPunchoutSearchController {
	@Autowired
	private BuyerMdCmCartPunchoutSearchService buyerMdCmCartPunchoutSearchService;
  
	// 조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmCartPunchOutList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmCartPunchOutList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );

		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("st_sort_flag", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		 
		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmCartPunchoutSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmCartPunchoutSearchList";
	}
	
	/**
	 * 조회
	 *  
 		삭제단종품 EXCEL 다운
	 * 
	 */
	@RequestMapping(value = "/mdcm/excelBuyerMdCmCartPunchOutList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public void excelBuyerMdCmCartPunchOutList(ModelMap pModel, HttpServletRequest req ,@RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
 
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId()); 
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );

		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("st_sort_flag", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		 
		List<Map<String, String>> _data = buyerMdCmCartPunchoutSearchService.getList(pMap);
	   
		String title = "";
		String headers = "";
		
		title = "품목코드|품목명|규격|원산지|제조사|단위|수량|카테고리번호|협력사|재고코드|통화재고구분|조달일수|";	
		headers = "BUYER_ITEM_NO|DESCRIPTION_LOC|SPECIFICATION|ORIGIN_NAME|MAKER_NAME|UNIT_MEASURE|CART_QTY|CATEGORY_NO|AGENT|TEMP_BUYER_ITEM_NO|CUR|DELIVERY_LT|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "장바구니.xls");	
		
	}
	
	@RequestMapping(value = "/mdcm/sendBuyerMdCmCartPunchoutOrderList.do", method = {RequestMethod.GET, RequestMethod.POST})	
	public String sendBuyerMdCmCartPunchoutOrderList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
	
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		String stUserId = _sessionInfo.getUserId();
		pMap.put("st_user_id_session",stUserId ); 
		pMap.put("st_com_code", _sessionInfo.getComCode() );
		
		if(!stUserId.equals("CHANGGYU.KIM")){
			buyerMdCmCartPunchoutSearchService.deleteBuyerMdCmCartListPunchOut(pMap);
		}
		
		return "buyer/mdcm/buyerMdCmCartPunchoutOrderList";
	}
	/**
	 * 저장
	 *  desc ICOMCART
 		 USE_FLAG	NOT NULL	CHAR(1)	용도구분(C:장바구니,D:,R:나의상품)
	 * 
	 */
	@RequestMapping(value = "/mdcm/saveBuyerMdCmCartQtyPunchOut.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdCmCartQtyPunchOut(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_user_id_session", _sessionInfo.getUserId()); 
		pMap.put("st_com_code", _sessionInfo.getComCode() );
		
		
		String msg = buyerMdCmCartPunchoutSearchService.saveBuyerMdCmCartQtyPunchOut(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
