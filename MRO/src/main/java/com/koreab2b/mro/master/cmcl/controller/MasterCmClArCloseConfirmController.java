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
import com.koreab2b.mro.master.cmcl.service.MasterCmClArCloseConfirmService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("masterCmClArCloseConfirmController")
public class MasterCmClArCloseConfirmController {

	@Autowired
	private MasterCmClArCloseConfirmService masterCmClArCloseConfirmService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClArCloseConfirmList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClArCloseConfirmList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClArCloseConfirmService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClArCloseConfirmList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClArCloseConfirmService.getList(pMap);
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
	
	// 마감 미제출자 팝업 조회
	@RequestMapping(value = "/cmcl/showMasterCmClArCloseConfirmPop.do",  method = {RequestMethod.GET,RequestMethod.POST})	
	public String showMasterCmClArCloseConfirmPop(ModelMap pModel, HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		pModel.addAllAttributes(pMap);
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal_M".equals(uiVersion)) {
			return "common/popup/cmcl/masterCmClArCloseConfirmPop_v2";	
		}else {
			return "common/popup/cmcl/masterCmClArCloseConfirmPop";		
		}
		
	}
	
	
	// 마감 미제출자 데이터 조회
	@RequestMapping(value = "/cmcl/getMasterCmClArCloseConfirmPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClArCloseConfirmPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterCmClArCloseConfirmService.getPopList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	@RequestMapping(value = "/cmcl/getMasterCmClArCloseConfirmPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterCmClArCloseConfirmPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterCmClArCloseConfirmService.getPopList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClArCloseConfirmList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClArCloseConfirm(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterCmClArCloseConfirmService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
