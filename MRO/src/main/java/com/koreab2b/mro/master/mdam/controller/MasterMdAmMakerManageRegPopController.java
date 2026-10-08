package com.koreab2b.mro.master.mdam.controller;

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

import com.koreab2b.mro.master.mdam.service.MasterMdAmMakerManageRegPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("MasterMdAmMakerManageRegPopController")
public class MasterMdAmMakerManageRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMakerManageRegPopController.class);

	@Autowired
	private MasterMdAmMakerManageRegPopService MasterMdAmMakerManageRegPopService;
	
	/**
	 * 제조사 관리 컨트롤러
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	
	/*등록*/
	@RequestMapping(value = "/mdam/regMasterMdAmMakerManageRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regMasterMdAmMakerManageRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		//날짜형식에서 '/' 제거
		formData = CommonUtil.removeSlash(formData);
		
		String rtnMsg = MasterMdAmMakerManageRegPopService.insertSelectedData(formData);

		_response.put("msg", rtnMsg);
		return _response;
		
	}	
	/**
	 * 수정
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdam/updateMasterMdAmMakerManageRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMakerManageRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		

		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		//날짜형식에서 '/' 제거
		formData = CommonUtil.removeSlash(formData);
		
		String rtnMsg = MasterMdAmMakerManageRegPopService.updateSelectedData(formData);
		
		_response.put("msg", rtnMsg);
		return _response;
		
	}	
	/* 조회 */
	@RequestMapping(value = "/mdam/getMasterMdAmMakerManageRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMdAmMakerManageRegPop(ModelMap pModel  ,HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		//pMap = CommonUtil.removeSlash(pMap);
		List<Map<String, String>> _data = MasterMdAmMakerManageRegPopService.getList(pMap); 	
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));    
		
		
		return "/common/popup/mdam/MasterMdAmMakerManageRegPop";
	}
	
	/**
	 * 대표 제조사 등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/regMasterMdAmMgMakerManageRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regMasterMdAmMgMakerManageRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		//날짜형식에서 '/' 제거
		formData = CommonUtil.removeSlash(formData);
		
		String rtnMsg = MasterMdAmMakerManageRegPopService.insertSelectedMgData(formData);

		_response.put("msg", rtnMsg);
		return _response;
		
	}
	
}
