package com.koreab2b.mro.master.wmre.controller;

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
import com.koreab2b.mro.master.wmre.service.MasterWmReReturnProgressStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmReReturnProgressStateController")
public class MasterWmReReturnProgressStateController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmReReturnProgressStateController.class);

	@Autowired
	private MasterWmReReturnProgressStateService masterWmReReturnProgressStateService;
	
	// 조회
	@RequestMapping(value = "/wmre/getMasterWmReReturnProgressStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterWmReReturnProgressStateList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = masterWmReReturnProgressStateService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
	
		return "master/wmre/masterWmReReturnProgressStateList";
	}
	@RequestMapping(value = "/wmre/getMasterWmReReturnProgressStateList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmReReturnProgressStateList_v2(HttpServletRequest req,ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("getMasterWmReReturnProgressStateList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		
		// 납품이슈현황 리스트 조회
		List<Map<String, String>> _data = masterWmReReturnProgressStateService.getMasterWmReReturnProgressStateList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

		
	// 저장
	@RequestMapping(value = "/wmre/saveMasterWmReReturnProgressStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmReReturnProgressState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmReReturnProgressStateService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/wmre/delMasterWmReReturnProgressStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmReReturnProgressState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmReReturnProgressStateService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
