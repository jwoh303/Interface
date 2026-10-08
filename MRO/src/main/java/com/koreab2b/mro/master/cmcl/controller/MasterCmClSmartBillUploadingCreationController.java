package com.koreab2b.mro.master.cmcl.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.cmcl.service.MasterCmClSmartBillUploadingCreationService;

@Controller("masterCmClSmartBillUploadingCreationController")
public class MasterCmClSmartBillUploadingCreationController {

	@Autowired
	private MasterCmClSmartBillUploadingCreationService masterCmClSmartBillUploadingCreationService;
	
	/**
	 * 스마트빌 전송상태 업데이트
	 * 
	 */
	@RequestMapping(value = "/cmcl/saveXXSBDtiStatusInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveXXSBDtiStatusInfo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = masterCmClSmartBillUploadingCreationService.saveXXSBDtiStatusInfo(pMap);
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 세금계산서 발행성공
	@RequestMapping(value = "/cmcl/sendSuccessSmartbill.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> sendSuccessSmartbill(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String rtnMsg =masterCmClSmartBillUploadingCreationService.sendSuccessSmartbill(pMap);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 세금계산서 발행실패
	@RequestMapping(value = "/cmcl/errorSendSmartBill.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> errorSendSmartBill(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String rtnMsg =masterCmClSmartBillUploadingCreationService.errorSendSmartBill(pMap);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 세금계산서 취소성공
	@RequestMapping(value = "/cmcl/cancleSuccessSmartBill.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> cancleSuccessSmartBill(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId()); // 사용자ID 	
		String rtnMsg =masterCmClSmartBillUploadingCreationService.cancleSuccessSmartBill(pMap);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
