package com.koreab2b.mro.master.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmStndCatalogConfirmService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmStndCatalogConfirmController")
public class MasterMdCmStndCatalogConfirmController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndCatalogConfirmController.class);

	@Autowired
	private MasterMdCmStndCatalogConfirmService masterMdCmStndCatalogConfirmService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogConfirmList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogConfirmList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmStndCatalogConfirmService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/*승인*/
	@RequestMapping(value = "/mdcm/saveMasterMpRqConfirmCatlg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqConfirmCatlg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMdCmStndCatalogConfirmService.saveMasterMpRqConfirmCatlg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/*반려*/
	@RequestMapping(value = "/mdcm/rejectMasterMpRqConfirmCatlg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectMasterMpRqConfirmCatlg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMdCmStndCatalogConfirmService.rejectMasterMpRqConfirmCatlg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
