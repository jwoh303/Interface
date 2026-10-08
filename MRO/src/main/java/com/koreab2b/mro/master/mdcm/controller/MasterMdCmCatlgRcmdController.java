package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatlgRcmdService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatlgRcmdController")
public class MasterMdCmCatlgRcmdController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatlgRcmdController.class);

	@Value("#{diquestProps['diquest.dqcat.ip']}")
	private String adminIp;

	@Value("#{diquestProps['diquest.dqcat.port']}")
	private String adminPort;
	
	@Value("#{diquestProps['diquest.collection.dqcat.catlg.real.name']}")
	private String collentionRealName;
	
	@Autowired
	private MasterMdCmCatlgRcmdService masterMdCmCatlgRcmdService;
	
	// 업로드 후 조회
	@RequestMapping(value = "/mdcm/getUploadMasterMdCmCatlgRcmdList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getUploadMasterMdCmCatlgRcmdList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmCatlgRcmdService.getUploadList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatlgRcmdList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatlgRcmdList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmCatlgRcmdService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// BNTTRXL 저장
	@RequestMapping(value = "/mdcm/uploadMasterMdCmCatlgRcmdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> uploadMasterMdCmCatlgRcmd(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("uploadMasterMdCmCatlgRcmd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatlgRcmdService.updateUploadData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 추천
	@RequestMapping(value = "/mdcm/updateMasterMdCmCatlgRcmdList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCatlgRcmd(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);

		formData.put("adminIp", adminIp);
		formData.put("adminPort", adminPort);
		formData.put("collentionRealName", collentionRealName);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("updateMasterMdCmCatlgRcmd MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatlgRcmdService.updateData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
