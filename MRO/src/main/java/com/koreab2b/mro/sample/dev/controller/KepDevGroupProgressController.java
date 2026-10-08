package com.koreab2b.mro.sample.dev.controller;

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

import com.koreab2b.mro.master.mprq.service.MasterMpRqBuyerReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("KepDevGroupProgressController")
public class KepDevGroupProgressController {

	private static final Logger LOGGER = LoggerFactory.getLogger(KepDevGroupProgressController.class);

	@Autowired
	private MasterMpRqBuyerReqService masterMpRqBuyerReqService;
	
	// 
	@RequestMapping(value = "/dev/saveKepDevGroupProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqBuyerReq(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		LOGGER.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		// 견적의뢰일
		String _st_btoa_date = _pMap.get("st_btoa_date").replace("/", "");
		_pMap.put("st_btoa_date",_st_btoa_date);
		
		Map<String, Object> _response = new HashMap<String, Object>();
//		int flag = masterMpRqBuyerReqService.updateSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
//		_response.put("resultFlag", flag);

		return _response;
	}
}
