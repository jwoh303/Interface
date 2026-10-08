package com.koreab2b.mro.common.mpiv.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpiv.service.CommonMpIvOrderDetailInfoPopService;
import com.koreab2b.mro.common.mpiv.service.CommonMpIvOrderDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonMpIvOrderDetailInfoPopController")
public class CommonMpIvOrderDetailInfoPopController {
 

	@Autowired
	private CommonMpIvOrderDetailInfoPopService commonMpIvOrderDetailInfoPopService;
	
	@Autowired
	private CommonMpIvOrderDetailPopService commonMpIvOrderDetailPopService;
	
	/**
	 * 발주 상세조회 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getCommonMpIvBuyerOrderDetailInfoPop2.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonMpIvOrderDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		
		Map<String, String> _dataMap = commonMpIvOrderDetailInfoPopService.getInfo(pMap);
		List<Map<String, String>> _data = commonMpIvOrderDetailPopService.getList(pMap);
		
		pModel.addAttribute("info", CommonUtil.getMapNvl(_dataMap)); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "/common/popup/mpiv/commonMpIvOrderDetailInfoPop";
	}	 
	
	
}
