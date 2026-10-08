package com.koreab2b.mro.common.mpds.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mpds.service.SellerMpDsDongbuPckpaprDesignSeedManagePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpDsDongbuPckpaprDesignSeedManagePopController")
public class SellerMpDsDongbuPckpaprDesignSeedManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsDongbuPckpaprDesignSeedManagePopController.class);

	@Autowired
	private SellerMpDsDongbuPckpaprDesignSeedManagePopService sellerMpDsDongbuPckpaprDesignSeedManagePopService;
	
	/**
	 * 동부포장지 도안관리(종자) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getSellerMpDsDongbuPckpaprDesignSeedManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpDsDongbuPckpaprDesignSeedManagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getSellerMpDsDongbuPckpaprDesignSeedManagePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpDsDongbuPckpaprDesignSeedManagePopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpds/sellerMpDsDongbuPckpaprDesignSeedManagePop";
	}	 
	
}
