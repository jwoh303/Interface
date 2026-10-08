package com.koreab2b.mro.master.cmcl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClLogisRateMngService;
import com.koreab2b.mro.master.cmcl.service.MasterCmClSalesTaxsheetCreationService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClLogisRateMngController")
public class MasterCmClLogisRateMngController {

	@Autowired
	private MasterCmClLogisRateMngService masterCmClLogisRateMngService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClLogisRateMngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClLogisRateMngList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		List<Map<String,String>> _data = masterCmClLogisRateMngService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClLogisRateMngList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterCmClLogisRateMngList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");		 
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("st_user_id",_sessionInfo.getUserId());
		 
		String rtnMsg = masterCmClLogisRateMngService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
		
	// 삭제
	@RequestMapping(value = "/cmcl/deleteMasterCmClLogisRateMngList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterCmClLogisRateMngList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");		 
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("st_user_id",_sessionInfo.getUserId());
		 
		String rtnMsg = masterCmClLogisRateMngService.deleteSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
		}
	
	// 예외기준 팝업 조회
	@RequestMapping(value = "/cmcl/showMasterCmClLogisRateMngFeePop.do",  method = {RequestMethod.GET,RequestMethod.POST})	
	public String showMasterCmClLogisRateMngFeePop(ModelMap pModel, HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		pModel.addAllAttributes(pMap);
		return "common/popup/cmcl/masterCmClLogisRateMngFeePop";		
	}
	
	// 예외기준 데이터 조회
	@RequestMapping(value = "/cmcl/getMasterCmClLogisRateMngFeePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClLogisRateMngFeePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterCmClLogisRateMngService.getFeeList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
