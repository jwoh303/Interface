package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mdct.service.MasterMdCtContractRegPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtContractRegPopController")
public class MasterMdCtContractRegPopController {
	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtStndrdContractDetailPopController.class);

	@Autowired
	private MasterMdCtContractRegPopService masterMdCtContractRegPopService;
	
	/**
	 * 표준계약서 조회 상세  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showMasterMdCtContractRegPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtContractRegPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getMasterMdCtContractRegPop.do 요청 파라미터 for jsp : {}", pMap);
		pMap.put("st_cont_chg_type",  CommonUtil.nvl(pMap.get("st_cont_chg_type"), ""));
		
		Map<String, String> _data = masterMdCtContractRegPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getMapNvl(_data)); 
		return "common/popup/mdct/masterMdCtContractRegPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtContractRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtContractRegPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_name", _sessionInfo.getUserNameLoc() );
		pMap.put("st_user_deptno", _sessionInfo.getDepartment());
		pMap.put("st_user_deptnm", _sessionInfo.getDepartmentName());
		
		pMap.put("st_corp_id", _sessionInfo.getComCode());
		pMap.put("st_corp_name", _sessionInfo.getComNameLoc());
		pMap.put("st_corp_deptnm", _sessionInfo.getDepartmentName());
		pMap.put("st_corp_email", _sessionInfo.getEmail());

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/saveMasterMdCtContractRegPop.do Map 요청 파라미터 : formData", pMap); 

		String flag = masterMdCtContractRegPopService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
}
