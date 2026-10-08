package com.koreab2b.mro.common.mdcp.controller;

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
import com.koreab2b.mro.common.mdcp.service.MasterMdCpSgMakerManagePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMdCpSgMakerManagePopController")
public class MasterMdCpSgMakerManagePopController {
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCpSgMakerManagePopController.class);

	@Autowired
	private MasterMdCpSgMakerManagePopService masterMdCpSgMakerManagePopService;
	
	/**
	 * 사용자 상세조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/showMasterMdCpSgMakerManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpSgMakerManagePop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("/mdcp/getMasterMdCpSgMakerManagePop.do 요청 파라미터 for jsp : {}", pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());	

		List<Map<String, String>> _compyData = masterMdCpSgMakerManagePopService.getCompyList(pMap);
		pModel.addAttribute("compyData", CommonUtil.getListNvl(_compyData));
		return "common/popup/mdcp/masterMdCpSgMakerManagePop";
	}
	
	// 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpSgMakerManagePopKepSgList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpSgMakerManagePopKepSgList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCpSgMakerManagePopService.getKepSgList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpSgMakerManagePopKepMkList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpSgMakerManagePopKepMkList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCpSgMakerManagePopService.getKepMkList(pMap);

		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpSgMakerManagePopRemark.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCpSgMakerManagePopRemark(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = masterMdCpSgMakerManagePopService.updateRemarkData(pMap);

		_response.put("msg", _rtnMsg);
		
		return _response;
	}
		
	// 저장
	@RequestMapping(value = "/mdcp/saveMasterMdCpSgMakerManagePopKepMkList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCpSgMakerManagePopKepMkList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCtBuyerChargeEntryList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCpSgMakerManagePopService.updateKepMkData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// SG삭제
	@RequestMapping(value = "/mdcp/deleteMasterMdCpSgMakerManagePopKepSgList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCpSgMakerManagePopKepSgList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("deleteMasterMdCpSgMakerManagePopKepSgList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("deleteMasterMdCpSgMakerManagePopKepSgList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCpSgMakerManagePopService.deleteKepSgData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// MK삭제
	@RequestMapping(value = "/mdcp/deleteMasterMdCpSgMakerManagePopKepMkList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCpSgMakerManagePopKepMkList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("deleteMasterMdCpSgMakerManagePopKepMkList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("deleteMasterMdCpSgMakerManagePopKepMkList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCpSgMakerManagePopService.deleteKepMkData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// MK복원
	@RequestMapping(value = "/mdcp/updateMasterMdCpSgMakerManagePopModMkList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpSgMakerManagePopModMkList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCpSgMakerManagePopModMkList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCpSgMakerManagePopModMkList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCpSgMakerManagePopService.updateModMkData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// MK승인
	@RequestMapping(value = "/mdcp/updateMasterMdCpSgMakerManagePopConfMkList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpSgMakerManagePopConfMkList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCpSgMakerManagePopConfMkList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCpSgMakerManagePopConfMkList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCpSgMakerManagePopService.updateConfMkData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
