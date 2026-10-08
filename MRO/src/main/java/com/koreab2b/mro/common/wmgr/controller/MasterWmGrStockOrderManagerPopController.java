package com.koreab2b.mro.common.wmgr.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmgr.service.MasterWmGrStockOrderManagerPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGrStockOrderManagerPopController")
public class MasterWmGrStockOrderManagerPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockOrderManagerPopController.class);

	@Autowired
	private MasterWmGrStockOrderManagerPopService masterWmGrStockOrderManagerPopService;
	
	
	/**
	 * 재고보충 발주 조회 및 삭제 상단 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/showMasterWmGrStockOrderManagerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrTrOrderGrRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/wmgr/showMasterWmGrStockOrderManagerPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmGrStockOrderManagerPopService.getPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgr/masterWmGrStockOrderManagerPop";
	}
	
	
	/**
	 * 재고보충 발주 조회 및 삭제 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrStockOrderManagerPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGrStockOrderManagerPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGrStockOrderManagerPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	// 저장
	@RequestMapping(value = "/wmgr/deleteMasterWmGrStockOrderManagerPopPoDel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterWmGrStockOrderManagerPopPoDel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData{}", gridData);
		String rtnMsg = masterWmGrStockOrderManagerPopService.deleteMasterWmGrStockOrderManagerPopPoDel(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	
	// 단가변경
	@RequestMapping(value = "/wmgr/deleteMasterWmGrStockOrderManagerPopPriceChange.do", method = RequestMethod.POST)
	@Transactional
	public Map<String, Object> deleteMasterWmGrStockOrderManagerPopPriceChange(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData{}", gridData);
		String rtnMsg = masterWmGrStockOrderManagerPopService.deleteMasterWmGrStockOrderManagerPopPriceChange(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 협력사변경
	@RequestMapping(value = "/wmgr/deleteMasterWmGrStockOrderManagerPopAgentChange.do", method = RequestMethod.POST)
	@Transactional
	public Map<String, Object> deleteMasterWmGrStockOrderManagerPopAgentChange(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData{}", gridData);
		String rtnMsg = masterWmGrStockOrderManagerPopService.deleteMasterWmGrStockOrderManagerPopAgentChange(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
}
