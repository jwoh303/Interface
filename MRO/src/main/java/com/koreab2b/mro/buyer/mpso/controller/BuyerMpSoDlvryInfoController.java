package com.koreab2b.mro.buyer.mpso.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoDlvryInfoService;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoOrderProgressService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpSoDlvryInfoController")
public class BuyerMpSoDlvryInfoController { 
 

	@Autowired
	private BuyerMpSoDlvryInfoService buyerMpSoDlvryInfoService;
	
	@Autowired
	private BuyerMpSoOrderProgressService buyerMpSoOrderProgressService;
	 
	//  배송정보
	@RequestMapping(value = "/mpso/getBuyerMpSoDlvryInfo.do", method = RequestMethod.POST)
	public String getBuyerMpSoDelayDlvyStateList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoDlvryInfo.do 요청 파라미터 : {}", pMap);
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
 
		List<Map<String, String>> _data = buyerMpSoDlvryInfoService.getList(pMap);
		String deptYn = buyerMpSoDlvryInfoService.getdeptYn(pMap);
				
		pModel.addAttribute("data", _data);
		pModel.addAttribute("deptYn", deptYn);
		
		return "buyer/mpso/buyerMpSoDlvryInfoList";
	} 
	
	
	/**
	 * 우편번호검증 PG_06_B_007_00
	 * /kr/customer/shopping_cart/check_zip_code.jsp
	 */
	@RequestMapping(value = "/mpso/checkZipCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> checkZipCode(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		String result = "";
		String msg = buyerMpSoDlvryInfoService.checkZipCode(pMap);
		if ("0".equals(msg)){
			result = "N";
		}else{
			result = "Y";
		}
		 
		_msg.put("MSG", result); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	/**
	 * 기본 배송정보 입력  PG_06_B_007_00
	 * /kr/customer/shopping_cart/buyer_delivery_info_update.jsp
	 */
	@RequestMapping(value = "/mpso/buyerDeliveryInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> buyerDeliveryInfo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		buyerMpSoDlvryInfoService.setUserInfoUpdate(pMap);
 
		 
		_msg.put("MSG", "UPDATE_OK"); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	
	//  수령희망일 입력
	@RequestMapping(value = "/mpso/getBuyerMpSoRecvDateRegisterPop.do", method =   {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpSoRecvDateRegisterPop(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoDlvryInfo.do 요청 파라미터 : {}", pMap);
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
 
		List<Map<String, String>> _data = buyerMpSoDlvryInfoService.getBuyerMpSoRecvDateRegisterPop(pMap);
		
		pModel.addAttribute("data", _data);
		
		return "common/popup/mpso/buyerMpSoRecvDateRegisterPop";
	} 
	
	
	
	
	   
	/**
	 * 배송조회 PG_06_B_070_00 - 주문진행조회와 동일
	 */
	@RequestMapping(value = "/mpso/getBuyerMpSoDlvryInfoSearchList.do", method = { RequestMethod.POST, RequestMethod.GET } )
	public String getBuyerMpSoDlvryInfoSearchList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mpso/getBuyerMpSoDlvryInfo.do 요청 파라미터 : {}", pMap);
		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_userid",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment()); 
		pMap.put("st_pr_mng_flag",_sessionInfo.getPrMngFlag()); 
		//String row_cnt = _sessionInfo.getRowCnt();
		
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
		pMap.put("fromDate", CommonUtil.onvl(pMap.get("fromDate") ,CommonUtil.addDate(new Date(),"M",-1,1)) );
		pMap.put("toDate", CommonUtil.onvl(pMap.get("toDate") ,CommonUtil.formatDateNoDateGubun(new Date(),1)) );
		pMap.put("st_pr_no", CommonUtil.onvl(pMap.get("st_pr_no") ,"") );		
		pMap.put("st_ref_no", CommonUtil.onvl(pMap.get("st_ref_no") ,"") );		
		pMap.put("st_search_no", CommonUtil.onvl(pMap.get("st_search_no") ,"") );
		pMap.put("st_search_type", CommonUtil.onvl(pMap.get("st_search_type") ,"") );		
		pMap.put("st_status", CommonUtil.onvl(pMap.get("st_status") ,"ALL") );
		pMap.put("st_sortType", CommonUtil.onvl(pMap.get("st_sortType") ,"DESC") );
		pMap.put("st_p060000114", CommonUtil.onvl(pMap.get("st_p060000114") ,"") );
		
		String _st_from_date = pMap.get("fromDate").replace("/", "");
		String _st_to_date = pMap.get("toDate").replace("/", "");
		pMap.put("fromDate",_st_from_date);
		pMap.put("toDate",_st_to_date);
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap); 
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpSoOrderProgressService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mpso/buyerMpSoDlvryInfoSearchList";
	} 
	
	/**
	 * 배송 	배송상태  상세조회 PG_06_B_070_00
	 */
	@SuppressWarnings("null")
	@RequestMapping(value = "/mpso/getBuyerMpSoDlvryInfoStatusList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBuyerMpSoDlvryInfoStatusList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer",_sessionInfo.getComCode()); 
		pMap.put("st_userid",_sessionInfo.getUserId());
		pMap.put("st_com_code",_sessionInfo.getComCode());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());  
		 
		
		Map<String, Object> _response = new HashMap<String, Object>();  		
		List<Map<String, String>> _data1 = buyerMpSoDlvryInfoService.getBuyerMpSoDlvryInfoStatusList( pMap );
		_data1 = CommonUtil.getListNvl(_data1);
		List<Map<String, String>> _data2 = null;
		Map<String, String> _data = null;
		if (_data1 != null ){
			if (_data1.size() >0){
				_data = new HashMap<String, String>();		
				_data = _data1.get(0);			
				_data.put("PR_NO", pMap.get("PR_NO"));
				_data.put("PR_SEQ", pMap.get("PR_SEQ"));
				_data.put("PO_NO", pMap.get("PO_NO"));
				_data.put("REF_NO", pMap.get("REF_NO"));
				_data.put("st_buyer", pMap.get("st_buyer"));
				_data2 = buyerMpSoDlvryInfoService.getBuyerMpSoDlvryInfoDtlList( _data );
			}
		}
 
		_response.put("data1", _data1);
		_response.put("data2", _data2); 
		return _response;
	} 
	
}
