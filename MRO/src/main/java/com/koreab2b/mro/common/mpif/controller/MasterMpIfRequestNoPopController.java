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

import com.koreab2b.mro.common.mpif.service.MasterMpIfRequestNoPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpIfRequestNoPopController")
public class MasterMpIfRequestNoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfRequestNoPopController.class);

	@Autowired
	private MasterMpIfRequestNoPopService masterMpIfRequestNoPopService;
	
	/**
	 * 요청번호 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	


	@RequestMapping(value = "/mpif/getMasterMpIfRequestNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpIfRequestNoPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("/mpif/getMasterMpIfRequestNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterMpIfRequestNoPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAllAttributes(pMap);
		return "common/popup/mpif/masterMpIfRequestNoPop";
	}	
	

	@RequestMapping(value = "/mpif/getMasterMpIfRequestNoDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIfRequestNoDetailPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpIfRequestNoPopService.getDetailList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 임시저장
	@RequestMapping(value = "/mpif/saveMasterMpIfRequestNoDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpIfRequestNoDetailPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterMpIfRequestNoPopService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}	
	
	// 단가저장
	@RequestMapping(value = "/mpif/savePriceMasterMpIfRequestNoDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savePriceMasterMpIfRequestNoDetailPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		Map<String,String> rtnMsg = masterMpIfRequestNoPopService.InsertSelectedPriceData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", rtnMsg.get("MSG"));
		mp.put("usrmsg",rtnMsg.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 구매발주
	@RequestMapping(value = "/mpif/poMasterMpIfRequestNoDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> poMasterMpIfRequestNoDetailPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterMpIfRequestNoPopService.updateSelectedDataPo(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}		
}
