package com.koreab2b.mro.common.mdcp.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mdcp.service.MasterMdCpUserDetailViewPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpUserDetailViewPopController")
public class MasterMdCpUserDetailViewPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpUserDetailViewPopController.class);

	@Autowired
	private MasterMdCpUserDetailViewPopService masterMdCpUserDetailViewPopService;
	
	/**
	 * 사용자 상세조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/showMasterMdCpUserDetailViewPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpUserDetailViewPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpUserDetailViewPop.do 요청 파라미터 for jsp : {}", pMap);
		
		/* 로그관련 셋팅 시작 */
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		/* 로그관련 셋팅 끝 */
		
		pMap.put("T_KEY","3972624753");
		List<Map<String, String>> _userData = masterMdCpUserDetailViewPopService.getList(pMap);
		List<Map<String, String>> _approvedData = masterMdCpUserDetailViewPopService.getApprovedList(pMap);
		List<Map<String, String>> _referData = masterMdCpUserDetailViewPopService.getReferList(pMap);
		
		pModel.addAttribute("userData", CommonUtil.getListNvl(_userData));
		pModel.addAttribute("approvedData", CommonUtil.getListNvl(_approvedData));
		pModel.addAttribute("referData", CommonUtil.getListNvl(_referData));
		
		return "common/popup/mdcp/masterMdCpUserDetailViewPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdcp/updateMasterMdCpUserDetailViewPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpUserDetailViewPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdcp/updateMasterMdCpUserDetailViewPop.do Map 요청 파라미터 : formData", pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		pMap.put("st_job_user_id", _sessionInfo.getUserId());
		String flag = masterMdCpUserDetailViewPopService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
}
