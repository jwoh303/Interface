package com.koreab2b.mro.common.mpif.controller;

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

import com.koreab2b.mro.common.mpif.service.MasterMpIfDivsnPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpIfDivsnPopController")
public class MasterMpIfDivsnPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfDivsnPopController.class);

	@Autowired
	private MasterMpIfDivsnPopService masterMpIfDivsnPopService;

	/**
	 * 분할 팝업 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpif/showMasterMpIfDivsnPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showMasterMpIfDivsnPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdam/getBuyerMdAmBudgetDepartmentChoicePop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data = masterMpIfDivsnPopService.getDivsnList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mpif/masterMpIfDivsnPop";
	}

	@RequestMapping(value = "/mpif/getMasterMpIfDivsnPop.do", method = { RequestMethod.GET, RequestMethod.POST })
	@ResponseBody
	public Map<String, Object> getMasterMpIfDivsnPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _data = masterMpIfDivsnPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data, pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpIfDivsnPopList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpIfDivsnPopList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		String rtnMsg = masterMpIfDivsnPopService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mpif/deleteMasterMpIfDivsnPopList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMpIfDivsnPopList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		String rtnMsg = masterMpIfDivsnPopService.deleteSelectedData(formData, gridData);
		_response.put("msg", rtnMsg);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
				
		return _response;
	}

}
