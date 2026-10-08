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

import com.koreab2b.mro.buyer.mdcm.service.BuyerMdCmMyPunchoutSearchService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdCmMyPunchoutSearchController")
public class BuyerMdCmMyPunchoutSearchController {
	@Autowired
	private BuyerMdCmMyPunchoutSearchService buyerMdCmMyPunchoutSearchService;
  
	// 조회
	@RequestMapping(value = "/mdcm/getBuyerMdCmMyPunchOutList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMdCmMyPunchOutList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
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
		pMap.put("st_category_no", CommonUtil.onvl(pMap.get("st_category_no") ,"") );
		pMap.put("st_sort_column", CommonUtil.onvl(pMap.get("st_sort_column") ,"ALL") );
		pMap.put("st_sort_flag", CommonUtil.onvl(pMap.get("st_sort_change") ,"") );
		/*
		* 고객사에 따라 카탈로그 검색기준이 다름
		* A: 두산엔진 KRHSDE0003
		*/
		String p060000055 = CommonUtil.getSpecialCheckReturn(_sessionInfo.getBycaComorgCode(),"P06-0000055","COL02_DATA"); // 검색조건변경
		if(p060000055.equals("A")){
			pMap.put("st_s_logic", p060000055);
			pMap.put("st_user_folder", CommonUtil.onvl(pMap.get("st_user_folder") ,"F0") );
		}else{
			pMap.put("st_s_logic", "R");
			pMap.put("st_user_folder", CommonUtil.onvl(pMap.get("st_user_folder") ,"") );
		}
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);  
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMdCmMyPunchoutSearchService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mdcm/buyerMdCmMyPunchoutSearchList";
	}
	
	/**
	 * 나의상품 삭제 
	 * 
	 */
	@RequestMapping(value = "/mdcm/removeBuyerMdCmMyPunchOutLisList.do", method = {RequestMethod.POST,RequestMethod.GET} )
	@ResponseBody
	public Map<String, Object> removeBuyerMdCmMyPunchOutLisList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		int msg = buyerMdCmMyPunchoutSearchService.removeBuyerMdCmMyPunchOutLisList(pMap);
		
		String createOk = "CREATE_OK";
		_msg.put("MSG", createOk); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	//EXCEL 다운로드	
	@RequestMapping(value = "/mdcm/excelBuyerMdCmMyPunchOutList.do", method = RequestMethod.POST)
	public void excelBuyerMdCmMyPunchOutList(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMdCmMyPunchoutSearchService.getExcelList(pMap);	   
	   
		String title = "";
		String headers = "";
		
		title = "순번|품목코드|품목명|규격|원산지|제조사|단위|단가|카테고리번호|협력사|재고코드|통화|재고구분|조달일수|";	//6		
		headers = "SEQ|BUYER_ITEM_NO2|DESCRIPTION_LOC|SPECIFICATION|ORIGIN_NAME|MAKER_NAME|UNIT_MEASURE|UNIT_PRICE|CATEGORY_NO|AGENT|ITEM_NO|CUR|GUBUN|DELIVERY_LT|";
		
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "나의상품검색.xls");	
		
	}
}
