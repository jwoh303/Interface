package com.koreab2b.mro.buyer.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqRequestQuotationPCOService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqRequestQuotationPCOController")
public class BuyerMpRqRequestQuotationPCOController {

	@Autowired
	private BuyerMpRqRequestQuotationPCOService buyerMpRqRequestQuotationPCOService;
	
	// 견적의뢰
	@RequestMapping(value = "/mprq/saveBuyerMpRqTempQuotationPCO.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqTempQuotationPCO(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		Map<String,String> _result = buyerMpRqRequestQuotationPCOService.updateSelectedTempData(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
	}
	


	// 임시저장 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqTempQuotationPCO.do", method = RequestMethod.POST)
	public String getBuyerMpRqTempQuotationPCO(ModelMap pModel,  HttpServletRequest req ,@RequestParam Map<String, String> pMap) {		
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		pMap.put("st_user_id", _sessionInfo.getUserId());			
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqRequestQuotationPCOService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "buyer/mprq/buyerMpRqRequestQuotationImSList";
	}
	
	// 임시저장 삭제
	@RequestMapping(value = "/mprq/deleteBuyerMpRqTempQuotationPCO.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteBuyerMpRqTempQuotationPCO(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		String msg = buyerMpRqRequestQuotationPCOService.deleteSelectedTempData(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 임시저장 삭제
	@RequestMapping(value = "/mprq/saveBuyerMpRqTempQuotationReqPCO.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqTempQuotationReqPCO(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		String msg = buyerMpRqRequestQuotationPCOService.saveSelectedTempReqData(pMap);
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
