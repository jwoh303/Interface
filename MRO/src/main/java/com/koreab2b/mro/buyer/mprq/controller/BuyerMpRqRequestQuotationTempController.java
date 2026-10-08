package com.koreab2b.mro.buyer.mprq.controller;

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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqRequestQuotationTempService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqRequestQuotationTempController")
public class BuyerMpRqRequestQuotationTempController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqRequestQuotationTempController.class);

	@Autowired
	private BuyerMpRqRequestQuotationTempService buyerMpRqRequestQuotationTempService;

	// 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqRequestQuotationTempList.do", method =  {RequestMethod.POST,RequestMethod.GET} )
	public String getBuyerMpRqTempSaveList(ModelMap pModel ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
 
		pMap.put("st_user_id",_sessionInfo.getUserId());
		pMap.put("st_user_dept",_sessionInfo.getDepartment());
		pMap.put("st_buyer",_sessionInfo.getComCode());
		pMap.put("st_byca_com_code",_sessionInfo.getBycaComorgCode());
		pMap.put("st_query", CommonUtil.onvl(pMap.get("st_query") ,"") );
		pMap.put("onepagerow", CommonUtil.onvl(pMap.get("onepagerow") ,"10") );
	 		 
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0");
		List<Map<String,String>> _data = buyerMpRqRequestQuotationTempService.getTempSaveList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqRequestQuotationTempList";
	}

	// 견적의뢰
	@RequestMapping(value = "/mprq/saveBuyerMpRqTempRequestList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqTempRequestList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		Map<String,String> _result = buyerMpRqRequestQuotationTempService.requestTempSaveList(pMap);
		 
		_msg.put("msg", _result.get("MSG"));
		_msg.put("usrmsg",_result.get("GW_NO"));
		_msg.put("passflag",_result.get("passflag"));
		_response.put("msg", _msg);
		
		return  _response;
	}
	@RequestMapping(value = "/mprq/saveBuyerMpRqTempRequestList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqTempRequestList_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		Map<String,String> _result = buyerMpRqRequestQuotationTempService.requestTempSaveList_v2(pMap);
		 
		_msg.put("msg", _result.get("MSG"));
		_msg.put("usrmsg",_result.get("GW_NO"));
		_msg.put("passflag",_result.get("passflag"));
		_response.put("msg", _msg);
		
		return  _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mprq/delBuyerMpRqTempSaveList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMpRqTempSaveList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = buyerMpRqRequestQuotationTempService.delTempSaveList(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		
		return  _response;
	}
	
	// 저장
	@RequestMapping(value = "/mprq/saveBuyerMpRqTempSaveList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqTempSaveList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		Map<String,String> _result = buyerMpRqRequestQuotationTempService.saveTempSaveList(pMap);
		 
		_msg.put("msg", _result.get("MSG"));
		_msg.put("usrmsg",_result.get("GW_NO"));
		_msg.put("passflag",_result.get("passflag"));
		_response.put("msg", _msg);
		
		return  _response;
	}
	// 저장
		@RequestMapping(value = "/mprq/saveBuyerMpRqTempSaveList_v2.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveBuyerMpRqTempSaveList_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
			Map<String, Object> _msg = new HashMap<String, Object>();		
			Map<String, Object> _response = new HashMap<String, Object>();
			
			Map<String,String> _result = buyerMpRqRequestQuotationTempService.saveTempSaveList_v2(pMap);
			 
			_msg.put("msg", _result.get("MSG"));
			_msg.put("usrmsg",_result.get("GW_NO"));
			_msg.put("passflag",_result.get("passflag"));
			_response.put("msg", _msg);
			
			return  _response;
		}
}
