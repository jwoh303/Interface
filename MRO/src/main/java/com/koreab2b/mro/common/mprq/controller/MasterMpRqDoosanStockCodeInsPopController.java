package com.koreab2b.mro.common.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqDoosanStockCodeInsPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqDoosanStockCodeInsPopController")
public class MasterMpRqDoosanStockCodeInsPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDoosanStockCodeInsPopController.class);

	@Autowired
	private MasterMpRqDoosanStockCodeInsPopService masterMpRqDoosanStockCodeInsPopService;
	
	/**
	 * 두중재고코드입력  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqDoosanStockCodeInsPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqDoosanStockCodeInsPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqDoosanStockCodeInsPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/*저장*/
	@RequestMapping(value = "/mprq/saveDoosanStockCode.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveDoosanStockCode(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterMpRqDoosanStockCodeInsPopService.saveDoosanStockCode(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
}
