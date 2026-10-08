package com.koreab2b.mro.common.mpiv.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvDlvryDetailInfoPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvBuyerDlvryDetailInfoPopController")
public class CommonMpIvBuyerDlvryDetailInfoPopController {

	@Autowired
	private CommonMpIvDlvryDetailInfoPopService commonMpIvDlvryDetailInfoPopService;
	
	/**
	 * 고객사 거래명세서 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerDlvryDetailInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvBuyerDlvryDetailInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, String> _dataMap = commonMpIvDlvryDetailInfoPopService.getInfo(pMap);
		List<Map<String, String>> _data = commonMpIvDlvryDetailInfoPopService.getList(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap)); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "/common/popup/mpiv/commonMpIvDlvryDetailInfoPop";
	}	 
	
}
