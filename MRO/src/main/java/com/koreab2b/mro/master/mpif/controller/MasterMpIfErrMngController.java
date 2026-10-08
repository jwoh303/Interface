package com.koreab2b.mro.master.mpif.controller;

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
import com.koreab2b.mro.master.mpif.service.MasterMpIfErrMngService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfErrMngController")
public class MasterMpIfErrMngController {

	@Autowired
	private MasterMpIfErrMngService masterMpIfErrMngService;
	private static final Logger logger = LoggerFactory.getLogger(MasterMpIfErrMngController.class);
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpifErrMng.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpifErrMng(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		logger.error("test0");
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		logger.error("test1");
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		logger.error("test2");
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfErrMngService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 전체집계
	@RequestMapping(value = "/mpif/runMasterMpifErrMngTotal.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> runMasterMpifErrMngTotal(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {	
		Map<String, Object> _response = new HashMap<String, Object>();

		String rtnMsg = "";
		rtnMsg = masterMpIfErrMngService.insertTotal(pMap);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 부분집계
	@RequestMapping(value = "/mpif/runMasterMpifErrMngSubTotal.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> runMasterMpifErrMngSubTotal(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = "";
		rtnMsg = masterMpIfErrMngService.insertSubTotal(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterNewMpifErrMng.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterNewMpifErrMng(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] _st_buyer_code_array = null;
		
		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterMpIfErrMngService.getNewList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
		
	
	//인터페이스 모니터링 상세 팝업
	@RequestMapping(value = "/mpif/showMpifNewErrMngPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String showMpifNewErrMngPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		String st_user_id = _sessionInfo.getUserId();
		pMap.put("st_user_id", st_user_id);
		List<Map<String, String>> _data = masterMpIfErrMngService.getMpifNewErrMngPop(pMap);
	
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("st_user_id", st_user_id);
		return "common/popup/mpif/mpifNewErrMngPop";
	}
	
	//인터페이스 모니터링 상세 팝업 저장
	@RequestMapping(value = "/mpif/saveMpifNewErrMngPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMpifNewErrMngPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpIfErrMngService.saveMpifNewErrMngPop(pMap);
		_response.put("msg", _result);
		return _response;
	}
		
}
