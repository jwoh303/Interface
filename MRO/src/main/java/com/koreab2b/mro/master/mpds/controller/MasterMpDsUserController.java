package com.koreab2b.mro.master.mpds.controller;

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
import com.koreab2b.mro.master.mpds.service.MasterMpDsUserService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpDsUserController")
public class MasterMpDsUserController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsUserController.class);

	@Autowired
	private MasterMpDsUserService masterMpDsUserService;

	// 조회
	@RequestMapping(value = "/mpds/getMasterMpDsUserList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpDsUserList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpDsUserService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	
	// 저장
	@RequestMapping(value = "/mpds/saveMasterMpDsUser.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpDsUser(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : _list", _list);
		logger.debug("saveMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMpDsUserService.updateSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("resultFlag", flag);

		return _response;
	}
}
