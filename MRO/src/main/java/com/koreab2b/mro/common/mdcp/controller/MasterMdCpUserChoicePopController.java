package com.koreab2b.mro.common.mdcp.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.mdcp.service.MasterMdCpUserChoicePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpUserChoicePopController")
public class MasterMdCpUserChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpUserChoicePopController.class);

	@Autowired
	private MasterMdCpUserChoicePopService masterMdCpUserChoicePopService;
	
	/**
	 * 사용자 선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/getMasterMdCpUserChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpUserChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/mdcp/getMasterMdCpUserChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		pMap.put("onepagerow", CommonUtil.nvl(pMap.get("onepagerow"), "10")); 
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		List<Map<String, String>> _data = masterMdCpUserChoicePopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mdcp/masterMdCpUserChoicePop";
	}
	
	/**
	 * 사용자 선택 조회 JSON (리뉴얼 v2 레이어팝업용)
	 */
	@RequestMapping(value = "/mdcp/getMasterMdCpUserChoiceList.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdCpUserChoiceList(@RequestParam Map<String, String> pMap) {
		pMap.put("onepagerow", CommonUtil.nvl(pMap.get("onepagerow"), "100"));
		pMap.put("paging", "0");

		List<Map<String, String>> _data = masterMdCpUserChoicePopService.getList(pMap);

		java.util.Map<String, Object> result = new java.util.HashMap<String, Object>();
		result.put("list", _data);
		return result;
	}

	/**
	 * 사용자 멀티 선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/getMasterMdCpUserMutiChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String getMasterMdCpUserMutiChoicePop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/mdcp/getMasterMdCpUserMutiChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		
		// 페이징처리
		pMap = CommonUtil.PagingPrc(pMap);
		
		pMap.put("onepagerow", CommonUtil.nvl(pMap.get("onepagerow"), "10")); 
		pMap.put("paging", (pMap.get("onepagerow") != null)? "1":"0"); 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		if(_sessionInfo != null){
			pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"), _sessionInfo.getUserId()));
		}else{
			pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"), ""));
		}
		
		List<Map<String, String>> _data = masterMdCpUserChoicePopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mdcp/masterMdCpUserMutiChoicePop";
	}
	
}
