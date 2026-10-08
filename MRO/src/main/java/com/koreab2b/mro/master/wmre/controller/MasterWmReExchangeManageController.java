package com.koreab2b.mro.master.wmre.controller;

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
import com.koreab2b.mro.master.wmre.service.MasterWmReExchangeManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmReExchangeManageController")
public class MasterWmReExchangeManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmReExchangeManageController.class);

	@Autowired
	private MasterWmReExchangeManageService masterWmReExchangeManageService;
	
	// 조회
	@RequestMapping(value = "/wmre/getMasterWmReExchangeManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String searchMasterWmReExchangeManageList(ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		logger.debug("요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = masterWmReExchangeManageService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "master/wmre/masterWmReExchangeManageList";
	}
	@RequestMapping(value = "/wmre/getMasterWmReExchangeManageList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterWmReExchangeManageList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = masterWmReExchangeManageService.getMasterWmReExchangeManageList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
		
	// 저장
	@RequestMapping(value = "/wmre/saveMasterWmReExchangeManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmReExchangeManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmReExchangeManageService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/wmre/delMasterWmReExchangeManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmReExchangeManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmReExchangeManageService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
