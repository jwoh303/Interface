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

import com.koreab2b.mro.common.wmgr.service.MasterWmGrStockGrDetailPopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmGrStockGrDetailPopController")
public class MasterWmGrStockGrDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmGrStockGrDetailPopController.class);

	@Autowired
	private MasterWmGrStockGrDetailPopService masterWmGrStockGrDetailPopService;
	
	/**
	 * 재고보충발주 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmgr/getMasterWmGrStockGrDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmGrStockGrDetailPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmGrStockGrDetailPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	// 저장
	@RequestMapping(value = "/wmgr/saveMasterWmGrStockGrDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmGrStockGrDetailPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmGrStockGrDetailPopService.updateSelectedData(formData, gridData);

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
