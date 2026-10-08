package com.koreab2b.mro.master.mpso.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpso.service.MasterMpSoPayRegMngUploadPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoPayRegMngUploadPopController")
public class MasterMpSoPayRegMngUploadPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoPayRegMngUploadPopController.class);

	@Autowired
	private MasterMpSoPayRegMngUploadPopService masterMpSoPayRegMngUploadPopService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoPayRegMngUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoPayRegMngUploadList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);		
		List<Map<String,String>> _data = masterMpSoPayRegMngUploadPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	@RequestMapping(value = "/mpso/getMasterMpSoPayRegMngUploadPoSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoPayRegMngUploadPoSearchPop(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, String> pMap) {		

		List<Map<String, String>> _data = masterMpSoPayRegMngUploadPopService.PoSearch(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mpso/masterMpSoPayRegMngUploadPoSearchPop";
	}
	
	@RequestMapping(value = "/mpso/saveMasterMpSoPayRegMngUploadExcel.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMpSoPayRegMngUploadExcel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoPayRegMngUploadPopService.saveExcelUploadData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	@RequestMapping(value = "/mpso/saveMasterMpSoPayRegMngUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMpSoPayRegMngUploadPopList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoPayRegMngUploadPopService.saveUploadList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	
	@RequestMapping(value = "/mpso/deleteMasterMpSoPayRegMngUploadList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMpSoPayRegMngUploadList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoPayRegMngUploadPopService.deleteUploadList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	
	
}
