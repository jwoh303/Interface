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

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.mpds.service.SellerMpDsPckpaprDesignCropProtectManagePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMpDsPckpaprDesignCropProtectManagePopController")
public class SellerMpDsPckpaprDesignCropProtectManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMpDsPckpaprDesignCropProtectManagePopController.class);

	@Autowired
	private SellerMpDsPckpaprDesignCropProtectManagePopService sellerMpDsPckpaprDesignCropProtectManagePopService;
	@Autowired
	private CommonInfoService commonInfoService;
	
	/**
	 * 포장지 도안관리(작물보호) 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpds/getSellerMpDsPckpaprDesignCropProtectManagePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMpDsPckpaprDesignCropProtectManagePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpds/getSellerMpDsPckpaprDesignCropProtectManagePop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = sellerMpDsPckpaprDesignCropProtectManagePopService.getList(pMap); 
		Map<String, String> userRole = commonInfoService.getUserRole(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("userRole", CommonUtil.nvlMap(userRole));
		pModel.addAllAttributes(pMap);
 
		return "common/popup/mpds/sellerMpDsPckpaprDesignCropProtectManagePop";
	}	 
	
}
