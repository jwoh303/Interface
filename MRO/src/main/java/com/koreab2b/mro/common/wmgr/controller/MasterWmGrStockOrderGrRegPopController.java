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

import com.koreab2b.mro.common.wmgr.service.MasterWmGrStockOrderGrRegPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGrStockOrderGrRegPopController")
public class MasterWmGrStockOrderGrRegPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockOrderGrRegPopController.class);

	@Autowired
	private MasterWmGrStockOrderGrRegPopService masterWmGrStockOrderGrRegPopService;
	
	/**
	 * 재고보충발주 입고등록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrStockOrderGrRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGrStockOrderGrRegPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGrStockOrderGrRegPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/wmgr/saveMasterWmGrStockOrderGrRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmGrStockGrCre(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData{}", gridData);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : pMap{}", pMap); 
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData{}", formData); 
		String rtnMsg = masterWmGrStockOrderGrRegPopService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("".equals(rtnMsg))
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
