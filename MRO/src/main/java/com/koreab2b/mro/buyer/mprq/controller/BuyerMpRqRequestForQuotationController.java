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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqRequestForQuotationService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqRequestForQuotationController")
public class BuyerMpRqRequestForQuotationController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqRequestForQuotationController.class);

	@Autowired
	private BuyerMpRqRequestForQuotationService buyerMpRqRequestForQuotationService;
	
	// 조회
	@RequestMapping(value = "/mprq/getBuyerMpRqRequestForQuotation.do", method = RequestMethod.POST)
	public String getBuyerMpRqRequestForQuotation(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		LOGGER.debug("요청 파라미터 : {}", pMap);

		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		// 화면 조회
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		List<Map<String, String>> _data = buyerMpRqRequestForQuotationService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "buyer/mprq/buyerMpRqRequestForQuotationList";
	}
	
	// 신청품의
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestForQuotation.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestForQuotation(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		Map<String,String> _result = buyerMpRqRequestForQuotationService.updateSelectedData(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
		
	}
	
	// 신청품의 - 결재N
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestForQuotationNoPassReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestForQuotationNoPassReq(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMpRqRequestForQuotationService.updateSelectedDataNoPass(_pMap, _list);
		_msg.put("msg", flag); 
		_response.put("msg", _msg);
		
		return  _response;
		
	}
	
	// 신청품의 - 결재O
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestForQuotationPassReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestForQuotationPassReq(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		Map<String,String> _result = buyerMpRqRequestForQuotationService.updateSelectedDataPass(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_response.put("msg", _msg);
		return  _response;
		
	}
	
	// 삭제
	@RequestMapping(value = "/mprq/delReqQuotation.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delReqQuotation(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		LOGGER.debug("saveBuyerMpRqRequestForQuotation MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMpRqRequestForQuotationService.delReqQuotation(_pMap, _list);
		_response.put("msg", flag);
		
		return  _response;
	}
	
}
