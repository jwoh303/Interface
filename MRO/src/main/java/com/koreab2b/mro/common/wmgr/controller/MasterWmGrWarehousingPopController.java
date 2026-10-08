package com.koreab2b.mro.common.wmgr.controller;

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

import com.koreab2b.mro.common.wmgr.service.MasterWmGrWarehousingPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGrWarehousingPopController")
public class MasterWmGrWarehousingPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrWarehousingPopController.class);

	@Autowired
	private MasterWmGrWarehousingPopService masterWmGrWarehousingPopService;

	
	/**
	 * TR 입고 조회 및 삭제 조회 상단 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/showMasterWmGrWarehousingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrWarehousingPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("/wmgr/showMasterWmGrWarehousingPop.do 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = masterWmGrWarehousingPopService.getPop(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));  //한건입니다. 
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgr/masterWmGrWarehousingPop";
	}	
	@RequestMapping(value = "/wmgr/showMasterWmGrWarehousingPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGrWarehousingPop_v2(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("/wmgr/showMasterWmGrWarehousingPop.do 요청 파라미터 for jsp : {}", pMap); 

		List<Map<String, String>> _data = masterWmGrWarehousingPopService.getPop_v2(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));  //한건입니다. 
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgr/masterWmGrWarehousingPop_v2";
	}	
	
	
	/**
	 * TR 입고 조회 및 삭제 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrWarehousingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGrWarehousingPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGrWarehousingPopService.getList(pMap);
//		Map<String, String> mMap =new HashMap<String, String>();
//		if( masterWmGrWarehousingPopService.getDetail(pMap).size() >0)
//		{
//			mMap = (Map<String, String>)masterWmGrWarehousingPopService.getDetail(pMap).get(0);
//		}
//		pMap.put("WMS_IVK_QTY", mMap.get("WMS_IVK_QTY"));
//		pMap.put("WMS_GR_QTY",  mMap.get("WMS_GR_QTY"));

		return IBSheetUtil.addResut(req, _data , pMap);
		
	}
	
	// 삭제
	@RequestMapping(value = "/wmgr/delMasterWmGrWarehousingPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmGrVmiWarhsng(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		

		
//		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterWmGrVmiWarhsng MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterWmGrWarehousingPopService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){
			
			mp.put("Code",1);
			
		}else{
			mp.put("Code",0);
		}
		
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	@RequestMapping(value = "/wmgr/delMasterWmGrWarehousingPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmGrVmiWarhsng_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		

		
//		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterWmGrVmiWarhsng MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterWmGrWarehousingPopService.delSelectedData_v2(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){
			
			mp.put("Code",1);
			
		}else{
			mp.put("Code",0);
		}
		
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
}
