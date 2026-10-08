package com.koreab2b.mro.common.mpds.controller;

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

import com.koreab2b.mro.common.mpds.service.MasterMpDsOrderCreationPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpDsOrderCreationPopController")
public class MasterMpDsOrderCreationPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpDsOrderCreationPopController.class);

	@Autowired
	private MasterMpDsOrderCreationPopService masterMpDsOrderCreationPopService;
	
	/**
	 * 발주생성 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getMasterMpDsOrderCreationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpDsOrderCreationPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpDsOrderCreationPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * 발주생성 이동
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/moveMasterMpDsOrderCreationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> moveMasterMpDsOrderCreationPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpDsOrderCreationPopService.moveList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	/**
	 * 발주등록
	 * @param pModel
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpds/insertMasterMpDsOrderCreationPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertMasterMpDsOrderCreationPop(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = masterMpDsOrderCreationPopService.insertSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("resultFlag", flag);

		return  _response;
	}	
	
}
