package com.koreab2b.mro.master.mdcm.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmChemicalMatInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmChemicalMatInfoController")
public class MasterMdCmChemicalMatInfoController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmChemicalMatInfoController.class);

	@Autowired
	private MasterMdCmChemicalMatInfoService masterMdCmChemicalMatInfoService;
	
	// 물질정보 상세 팝업 조성정보 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmChemicalMatInfoHdList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmChemicalMatInfoHdList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_id", _sessionInfo.getUserId());
		logger.debug("getSellerMdCtChemicalMatRegPop 요청 파라미터 : {}", pMap);		
		List<Map<String, String>> _data = masterMdCmChemicalMatInfoService.getMasterMdCmChemicalMatInfoHdList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdcm/masterMdCmChemicalMatInfo";
	}
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmChemicalMatInfoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmChemicalMatInfoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmChemicalMatInfoService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 취소
	@RequestMapping(value = "/mdcm/cancleMasterMdCmChemicalMatInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleMasterMdCmChemicalMatInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatInfoService.cancleMasterMdCmChemicalMatInfo(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 저장
	@RequestMapping(value = "/mdcm/saveMasterMdCmChemicalMatInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmChemicalMatInfo(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmChemicalMatInfoService.saveMasterMdCmChemicalMatInfo(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
