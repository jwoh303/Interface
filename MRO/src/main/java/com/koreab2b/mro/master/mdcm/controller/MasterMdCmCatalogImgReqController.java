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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogImgReqService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogImgReqController")
public class MasterMdCmCatalogImgReqController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogImgReqController.class);

	@Autowired
	private MasterMdCmCatalogImgReqService masterMdCmCatalogImgReqService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogImgList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogImgList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmCatalogImgReqService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/*승인*/
	@RequestMapping(value = "/mdcm/saveMasterMpRqConfirmStndCatlg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqConfirmStndCatlg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMdCmCatalogImgReqService.saveMasterMpRqConfirmStndCatlg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/*반려*/
	@RequestMapping(value = "/mdcm/rejectMasterMpRqConfirmStndCatlg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectMasterMpRqConfirmStndCatlg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMdCmCatalogImgReqService.rejectMasterMpRqConfirmStndCatlg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
