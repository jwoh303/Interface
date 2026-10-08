package com.koreab2b.mro.master.cmcl.controller;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClMenuService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClMenuController")
public class MasterCmClMenuController {

	private static final Logger logger = LoggerFactory.getLogger(MasterCmClMenuController.class);

	@Autowired
	private MasterCmClMenuService masterCmClMenuService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClMenuList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterCmClMenuList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterCmClMenuService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClMenuList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterCmClMenuService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClMenuList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClMenu(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClMenuService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/cmcl/delMasterCmClMenuList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClMenu(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClMenuService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}

}
