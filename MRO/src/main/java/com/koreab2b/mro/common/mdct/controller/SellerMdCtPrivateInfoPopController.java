package com.koreab2b.mro.common.mdct.controller;

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

import com.koreab2b.mro.common.mdct.service.SellerMdCtPrivateInfoPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtPrivateInfoPopController")
public class SellerMdCtPrivateInfoPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtPrivateInfoPopController.class);

	@Autowired
	private SellerMdCtPrivateInfoPopService sellerMdCtPrivateInfoPopService;
	
	/**
	 * 개인정보 조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showSellerMdCtPrivateInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMdCtPrivateInfoPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getSellerMdCtPrivateInfoPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_com_code", _sessionInfo.getComCode());
		
		List<Map<String, String>> _data = sellerMdCtPrivateInfoPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/sellerMdCtPrivateInfoPop";
	}	 
	
}
