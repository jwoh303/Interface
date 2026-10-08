package com.koreab2b.mro.master.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.mdct.service.MasterMdCtCustomerInfoManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtCustomerInfoManageController")
public class MasterMdCtCustomerInfoManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtCustomerInfoManageController.class);
	
	@Autowired
	private MasterMdCtCustomerInfoManageService masterMdCtCustomerInfoManageService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtCustomerInfoManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtCustomerInfoManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtCustomerInfoManageList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtCustomerInfoManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 엑셀다운로드
	@RequestMapping(value = "/mdct/excelMasterMdCtCustomerInfoManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpSoProgressDownLoad(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtCustomerInfoManageService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	// 카탈로그조회 등록 일괄 (엑셀업로드)
	@RequestMapping(value = "/mdct/uploadMasterMdCtCustomerInfoManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> uploadMasterMdCtCustomerInfoManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("uploadMasterMdCtCustomerInfoManageList MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCtCustomerInfoManageService.uploadMasterMdCtCustomerInfoManage(formData, gridData);
		_response.put("msg", rtnMsg);
		return _response;
	}
	// 잠재고객 등록 팝업
	@RequestMapping(value = "/mdct/getMasterMdCtCustomerInfo.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtCustomerInfo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_session_id", _sessionInfo.getUserId()); // 사용자ID	
		
		List<Map<String, String>> _data = masterMdCtCustomerInfoManageService.getCustomerInfo(pMap);

		pModel.addAttribute("dataMdCt", CommonUtil.getListNvl(_data));
		return "common/popup/mdct/masterMdctNewCustomerPop";
	}

}
