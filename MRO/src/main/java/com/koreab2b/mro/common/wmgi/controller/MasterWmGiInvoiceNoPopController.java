package com.koreab2b.mro.common.wmgi.controller;

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

import com.koreab2b.mro.common.wmgi.service.MasterWmGiInvoiceNoPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGiInvoiceNoPopController")
public class MasterWmGiInvoiceNoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGiInvoiceNoPopController.class);

	@Autowired
	private MasterWmGiInvoiceNoPopService masterWmGiInvoiceNoPopService;
	
	/**
	 * 출고조회 및 삭제 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgi/getMasterWmGiInvoiceNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGiInvoiceNoPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGiInvoiceNoPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 조회
	@RequestMapping(value = "/wmgi/showMasterWmGiInvoiceNoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmGiInvoiceNoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String, String>> _data = masterWmGiInvoiceNoPopService.getPop(pMap);
		
		if(_data != null && _data.size() >0 ){
			pMap.put("LEGACY_PO_NO", CommonUtil.nvl(_data.get(0).get("LEGACY_PO_NO")));
			String _dataDoosan = masterWmGiInvoiceNoPopService.getDoosan(pMap);
			pModel.addAttribute("_dataDoosan", _dataDoosan);
		}

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("/mdcd/showMasterWmDlInvoiceNoPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmgi/masterWmGiInvoiceNoPop";
	}
	/**
	 * 배송 삭제 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgi/getMasterWmIvkConfirmDeletePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmIvkConfirmDeletePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGiInvoiceNoPopService.getListDelevery(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	   // 저장
		@RequestMapping(value = "/wmgi/saveMasterWmIvkConfirmDeletePop.do", method = RequestMethod.POST)
		@ResponseBody
		@Transactional
		public Map<String, Object> updateMasterWmIvkConfirmDeletePop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			logger.debug("요청 파라미터 : gridData{}", gridData);
			String rtnMsg = masterWmGiInvoiceNoPopService.updateSelectedDataDelevery(formData, gridData);

			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			logger.debug("리턴  파라미터 :"+ rtnMsg);
			if(rtnMsg.substring(0,2).equals("OK"))
			{
				mp.put("Code",1);
				
			}else{
				
				mp.put("Code",0);
			}

			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
			
		}		
	   // 저장
		@RequestMapping(value = "/wmgi/saveMasterWmGiInvoiceNoPop.do", method = RequestMethod.POST)
		@ResponseBody
		@Transactional
		public Map<String, Object> updateMasterWmGiInvoiceNoPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
			Map<String, Object> _response = new HashMap<String, Object>();
			
			// gridData
			List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
			// formData
			Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
			
			logger.debug("요청 파라미터 : gridData{}", gridData);
			String rtnMsg = masterWmGiInvoiceNoPopService.updateSelectedData(formData, gridData);

			/* 성공시코드 1 , 실패시 0 */
			Map<String, Object> mp = new HashMap<String, Object>();
			logger.debug("리턴  파라미터 :"+ rtnMsg);
			if(rtnMsg.substring(0,2).equals("OK"))
			{
				mp.put("Code",1);
				
			}else{
				
				mp.put("Code",0);
			}

			_response.put("Result",mp);
			_response.put("Message", rtnMsg);
			return _response;
			
		}		
}
