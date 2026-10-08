package com.koreab2b.mro.master.mdcm.controller;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmChemicalMatMngService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmChemicalMatMngController")
public class MasterMdCmChemicalMatMngController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmChemicalMatMngController.class);

	@Autowired
	private MasterMdCmChemicalMatMngService masterMdCmChemicalMatMngService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmChemicalMatMngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmChemicalMatMngList(HttpServletRequest req , @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmChemicalMatMngService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 협력사반려
	@RequestMapping(value = "/mdcm/returnMasterrMdCtChemicalMat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> returnMasterrMdCtChemicalMat(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatMngService.returnMasterrMdCtChemicalMat(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 검토요청
	@RequestMapping(value = "/mdcm/reqMasterrMdCtChemicalMat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> reqMasterrMdCtChemicalMat(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatMngService.reqMasterrMdCtChemicalMat(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 상태변경
	@RequestMapping(value = "/mdcm/updateStatusMasterrMdCtChemicalMat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateCategMasterrMdCtChemicalMat(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatMngService.updateStatusMasterrMdCtChemicalMat(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 최종승인
	@RequestMapping(value = "/mdcm/confirmMasterrMdCtChemicalMat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> confirmMasterrMdCtChemicalMat(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatMngService.confirmMasterrMdCtChemicalMat(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 발주 후 제출
	@RequestMapping(value = "/mdcm/afterMasterrMdCtChemicalMat.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> afterMasterrMdCtChemicalMat(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatMngService.afterMasterrMdCtChemicalMat(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmChemicalMatMngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmChemicalMatMngService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
}
