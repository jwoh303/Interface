package com.koreab2b.mro.common.mdcm.controller;

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

import com.koreab2b.mro.common.mdcm.service.MasterMdCmCatalogBuyerChoicePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogBuyerChoicePopController")
public class MasterMdCmCatalogBuyerChoicePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogBuyerChoicePopController.class);

	@Autowired
	private MasterMdCmCatalogBuyerChoicePopService masterMdCmCatalogBuyerChoicePopService;
	
	/**
	 * 카탈로그 고객사선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogBuyerChoicePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmCatalogBuyerChoicePop(ModelMap pModel,  HttpServletRequest req,@RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmCatalogBuyerChoicePop.do 요청 파라미터 for jsp : {}", pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_id",_sessionInfo.getUserId());
		List<Map<String, String>> _data = masterMdCmCatalogBuyerChoicePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcm/masterMdCmCatalogBuyerChoicePop";
	}	 
	
}
