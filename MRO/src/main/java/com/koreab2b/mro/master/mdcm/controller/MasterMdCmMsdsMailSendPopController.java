package com.koreab2b.mro.master.mdcm.controller;

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

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmMsdsMailSendPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmMsdsMailSendPopController")
public class MasterMdCmMsdsMailSendPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmMsdsMailSendPopController.class);

	@Autowired
	private MasterMdCmMsdsMailSendPopService masterMdCmMsdsMailSendPopService;
	

	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdcmMsdsMailSendPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterMdcmMsdsMailSendPopList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		List<Map<String,String>> _data = masterMdCmMsdsMailSendPopService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	// 메일전송
	@RequestMapping(value = "/mdcm/saveMasterMdcmMsdsMailSendPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmMsdsEmailSend(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCmMsdsMailSendPopService.saveMasterMdcmMsdsMailSend(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	
	// 메일 MSDS 파일 다운로드 팝업 & 수신여부 업데이트
	@RequestMapping(value = "/mdcm/getMasterMdcmMsdsMailDownloadPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String getMasterMdcmMsdsMailDownloadPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		
		masterMdCmMsdsMailSendPopService.saveMailRecv(pMap);
		return "common/popup/fileUploadPop";
	}
}
