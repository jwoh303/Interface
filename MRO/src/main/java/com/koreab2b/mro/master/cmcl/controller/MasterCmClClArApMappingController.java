package com.koreab2b.mro.master.cmcl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.cmcl.service.MasterCmClClArApMappingService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClClArApMappingController")
public class MasterCmClClArApMappingController {

	@Autowired
	private MasterCmClClArApMappingService masterCmClClArApMappingService;
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterCmClClArApMappingController.class);
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClArApMappingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClArApMappingList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterCmClClArApMappingService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 세금계산서조회
	@RequestMapping(value = "/cmcl/getMasterCmClTaxMappingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClTaxMappingList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterCmClClArApMappingService.getTaxList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 세금계산서 상계처리 매핑
	@RequestMapping(value = "/cmcl/callProcTaxSkip.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> callProcTaxSkip(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		 
		String msg = masterCmClClArApMappingService.callProcTaxSkip(pMap);

		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		
		return _response;
	}
	
	// 세금계산서 수동 상계처리
	@RequestMapping(value = "/cmcl/manProcTaxSkip.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> manProcTaxSkip(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClClArApMappingService.updateProcTaxSkip(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
		
	// 매출 자동매핑
	@RequestMapping(value = "/cmcl/callProcTaxMappingAr.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> callProcTaxMappingAr(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		 
		String msg = masterCmClClArApMappingService.callProcTaxMappingAr(pMap);

		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		
		return _response;
	}
	
	// 매입 자동매핑
	@RequestMapping(value = "/cmcl/callProcTaxMappingAp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> callProcTaxMappingAp(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		 
		String msg = masterCmClClArApMappingService.callProcTaxMappingAp(pMap);

		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		
		return _response;
	}
	// 저장
	@RequestMapping(value = "/cmcl/savetMasterCmClArApMappingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savetMasterCmClArApMappingList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		 
		String msg = masterCmClClArApMappingService.savetMasterCmClArApMappingList(pMap);

		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		
		return _response;
	}
	// 저장
		@RequestMapping(value = "/cmcl/saveExceptionMasterCmClArApMappingList.do", method = RequestMethod.POST)
		@ResponseBody
		public Map<String, Object> saveExceptionMasterCmClArApMappingList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			 
			String rtnMsg = masterCmClClArApMappingService.saveExceptionMasterCmClArApMappingList(formData, gridData);

			// 성공시 : 1 실패시 : 0
			Map<String, Object> mp = new HashMap<String, Object>();
			mp.put("Code",1);
			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			
			return _response;
		}
	// 확정
	@RequestMapping(value = "/cmcl/confirmMasterCmClArApMappingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> confirmtMasterCmClArApMappingList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClClArApMappingService.confirmtMasterCmClArApMappingList(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 매핑취소
	@RequestMapping(value = "/cmcl/cancleMappingMasterCmClArApMappingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMappingMasterCmClArApMappingList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClClArApMappingService.cancleMappingMasterCmClArApMappingList(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 취소
	@RequestMapping(value = "/cmcl/cancleMasterCmClArApMappingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterCmClArApMappingList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClClArApMappingService.cancleMasterCmClArApMappingList(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
