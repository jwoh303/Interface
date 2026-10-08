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

import com.koreab2b.mro.buyer.mprq.service.BuyerMpRqRequestQuotationStndService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpRqRequestQuotationStndController")
public class BuyerMpRqRequestQuotationStndController {

	private static final Logger LOGGER = LoggerFactory.getLogger(BuyerMpRqRequestQuotationStndController.class);

	@Autowired
	private BuyerMpRqRequestQuotationStndService buyerMpRqRequestQuotationStndService;

	// 견적의뢰(결재N)
	@RequestMapping(value = "/mprq/saveNoPassReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveNoPassReq(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		String flag = buyerMpRqRequestQuotationStndService.updateSelectedDataNoPass(_pMap, _list);
		_msg.put("msg", flag); 
		_response.put("msg", _msg);

		return  _response;
	}
	// 견적의뢰(결재N)
		@RequestMapping(value = "/mprq/saveNoPassReq_v2.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveNoPassReq_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

			// gridData
			List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
			
			Map<String, Object> _response = new HashMap<String, Object>();
			Map<String, Object> _msg = new HashMap<String, Object>();		
			LOGGER.debug("요청 파라미터 : _list {}", pMap);
			
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
			_pMap.put("st_user_id", _sessionInfo.getUserId());	
			_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
			_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
			_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
			_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
			_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
			
			String flag = buyerMpRqRequestQuotationStndService.updateSelectedDataNoPass_v2(_pMap, _list);
			_msg.put("msg", flag); 
			_response.put("msg", _msg);

			return  _response;
		}
	
	// 견적의뢰(결재Y)
	@RequestMapping(value = "/mprq/savePassReq.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savePassReq(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedDataPass(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_response.put("msg", _msg);
		return  _response;
		
	}
	// 견적의뢰(결재Y)
		@RequestMapping(value = "/mprq/savePassReq_v2.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> savePassReq_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			
			// gridData
			List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
			
			Map<String, Object> _response = new HashMap<String, Object>();
			Map<String, Object> _msg = new HashMap<String, Object>();		
			LOGGER.debug("요청 파라미터 : _list {}", pMap);
			
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
			_pMap.put("st_user_id", _sessionInfo.getUserId());	
			_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
			_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
			_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
			_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
			_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
			
			Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedDataPass_v2(_pMap, _list);
			_msg.put("msg", _result.get("MSG")); 
			_msg.put("usrmsg",_result.get("GW_NO")); 
			_response.put("msg", _msg);
			return  _response;
			
		}
	
	
	// 견적의뢰
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestQuotationStnd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestQuotationStnd(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedData(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
	}
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestQuotationStnd_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestQuotationStnd_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedData_v2(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
	}

	// 견적의뢰 임시저장
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestQuotationTemp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestQuotationTemp(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedDataTemp(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
	}
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestQuotationTemp_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestQuotationTemp_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, Object> _msg = new HashMap<String, Object>();		
		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		_pMap.put("st_buyer", _sessionInfo.getComCode()); 	
		_pMap.put("st_user_id", _sessionInfo.getUserId());	
		_pMap.put("st_user_name", _sessionInfo.getUserNameLoc());	
		_pMap.put("st_user_dept", _sessionInfo.getDepartment()); 	
		_pMap.put("st_btoa_user_mail", _sessionInfo.getEmail()); 	
		_pMap.put("st_btoa_user_tel", _sessionInfo.getTel()); 	
		_pMap.put("st_btoa_user_fax", _sessionInfo.getFax()); 	
		
		Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedDataTemp_v2(_pMap, _list);
		_msg.put("msg", _result.get("MSG")); 
		_msg.put("usrmsg",_result.get("GW_NO")); 
		_msg.put("passflag",_result.get("passflag")); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	// 미계약품 견적의뢰
	@RequestMapping(value = "/mprq/saveBuyerMpRqRequestQuotationGpl.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMpRqRequestQuotationGpl(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		LOGGER.debug("요청 파라미터 : _list {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		//logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("st_buyer", _sessionInfo.getComCode() );
		
		
		Map<String,String> _result = buyerMpRqRequestQuotationStndService.updateSelectedDataTempGpl(pMap);
		_msg.put("MSG", _result.get("MSG")); 
		_response.put("msg", _msg);
		return  _response;
	}
	
}
