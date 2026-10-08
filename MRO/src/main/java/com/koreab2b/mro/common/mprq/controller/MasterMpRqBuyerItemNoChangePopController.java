package com.koreab2b.mro.common.mprq.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mprq.service.MasterMpRqBuyerItemNoChangePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpRqBuyerItemNoChangePopController")
public class MasterMpRqBuyerItemNoChangePopController {

	@Autowired
	private MasterMpRqBuyerItemNoChangePopService masterMpRqBuyerItemNoChangePopService;
	
	/**
	 * 카탈로그 등록여부  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqBuyerItemNoChangePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpRqBuyerItemNoChangePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		// 화면 조회
		List<Map<String, String>> _data = masterMpRqBuyerItemNoChangePopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mprq/masterMpRqBuyerItemNoChangePop";
		
	}	 
	
}
