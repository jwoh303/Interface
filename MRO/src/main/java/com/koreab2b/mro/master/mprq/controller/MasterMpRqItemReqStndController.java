package com.koreab2b.mro.master.mprq.controller;

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
import com.koreab2b.mro.master.mprq.service.MasterMpRqItemReqStndService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqItemReqStndController")
public class MasterMpRqItemReqStndController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqItemReqStndController.class);

	@Autowired
	private MasterMpRqItemReqStndService masterMpRqItemReqStndService;
	
	// 조회
	@RequestMapping(value = "/mprq/masterMpRqItemReqStnd.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> masterMpRqItemReqStnd(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

//		Map<String, Object> _response = new HashMap<String, Object>();
		String _st_req_from_date = ((String) pMap.get("st_req_from_date")).replace("/", "");
		String _st_req_to_date = ((String) pMap.get("st_req_to_date")).replace("/", "");
		
		pMap.put("st_req_from_date",_st_req_from_date);
		pMap.put("st_req_to_date",_st_req_to_date);
		
		List<Map<String,String>> _data = masterMpRqItemReqStndService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장(FeedBack)
	@RequestMapping(value = "/mprq/saveMasterMpRqItemReqStnd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqItemReqStnd(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : _list", _list);
		LOGGER.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", _pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = masterMpRqItemReqStndService.updateSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("resultFlag", flag);
		return _response;
	}
}
