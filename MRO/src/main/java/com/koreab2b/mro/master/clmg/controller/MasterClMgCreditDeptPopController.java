package com.koreab2b.mro.master.clmg.controller;

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
import com.koreab2b.mro.master.clmg.service.MasterClMgCreditDeptPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterClMgCreditDeptPopController")
public class MasterClMgCreditDeptPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterClMgCreditDeptPopController.class);

	@Autowired
	private MasterClMgCreditDeptPopService masterClMgCreditDeptPopService;
	
	/**
	 * 여신한도 고객사코드 매핑리스트
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/getMasterClMgCreditDeptPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterClMgCreditDeptPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterClMgCreditDeptPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 여신한도 고객사코드 매핑저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/saveMasterClMgCreditDeptPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterClMgCreditDeptPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterClMgCreditDeptPopService.saveMasterClMgCreditDeptPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/**
	 * 여신한도 고객사코드 매핑삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/deleteMasterClMgCreditDeptPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterClMgCreditDeptPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterClMgCreditDeptPopService.deleteMasterClMgCreditDeptPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/**
	 * 여신한도 고객사여신 매핑리스트
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/getMasterClMgCreditBondPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterClMgCreditBondPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterClMgCreditDeptPopService.getMasterClMgCreditBondPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 여신한도 고객사여신 매핑저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/saveMasterClMgCreditBondPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterClMgCreditBondPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterClMgCreditDeptPopService.saveMasterClMgCreditBondPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/**
	 * 여신한도 고객사여신 매핑삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/deleteMasterClMgCreditBondPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterClMgCreditBondPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterClMgCreditDeptPopService.deleteMasterClMgCreditBondPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/**
	 * 여신한도 고객사여신예외 매핑리스트
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/getMasterClMgBondExcpPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterClMgBondExcpPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterClMgCreditDeptPopService.getMasterClMgBondExcpPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 여신한도 고객사여신 매핑저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/saveMasterClMgBondExcpPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterClMgBondExcpPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterClMgCreditDeptPopService.saveMasterClMgBondExcpPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/**
	 * 여신한도 고객사여신 매핑삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/deleteMasterClMgBondExcpPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterClMgBondExcpPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterClMgCreditDeptPopService.deleteMasterClMgBondExcpPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
