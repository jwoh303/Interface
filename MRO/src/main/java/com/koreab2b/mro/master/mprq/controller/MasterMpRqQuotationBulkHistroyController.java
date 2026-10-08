package com.koreab2b.mro.master.mprq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.mprq.service.MasterMpRqQuotationBulkHistroyService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMpRqQuotationBulkHistroyController")
public class MasterMpRqQuotationBulkHistroyController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqQuotationBulkHistroyController.class);

	@Autowired
	private MasterMpRqQuotationBulkHistroyService MasterMpRqQuotationBulkHistroyService;
	
	// 조회
	@RequestMapping(value = "/mprq/getMasterMpRqQuotationBulkHistroyList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpRqQuotationBulkHistroyList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = MasterMpRqQuotationBulkHistroyService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}


	// 저장
	@RequestMapping(value = "/mprq/saveMasterMpRqQuotationBulkHistroyList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqQuotationBulkHistroy(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = MasterMpRqQuotationBulkHistroyService.insertSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

}
