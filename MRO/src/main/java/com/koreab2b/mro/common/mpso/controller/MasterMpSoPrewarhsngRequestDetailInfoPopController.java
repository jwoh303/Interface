package com.koreab2b.mro.common.mpso.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpso.service.MasterMpSoPrewarhsngRequestDetailInfoPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoPrewarhsngRequestDetailInfoPopController")
public class MasterMpSoPrewarhsngRequestDetailInfoPopController {

	@Autowired
	private MasterMpSoPrewarhsngRequestDetailInfoPopService masterMpSoPrewarhsngRequestDetailInfoPopService;
	
	/**
	 * 선입고요청 상세정보 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoPrewarhsngRequestDetailInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoPrewarhsngRequestDetailInfoPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"), ""));
		pMap.put("st_bs_no", CommonUtil.nvl((String) pMap.get("st_bs_no"), ""));
		Map<String,String> _data = masterMpSoPrewarhsngRequestDetailInfoPopService.getDetail(pMap);
		pModel.addAttribute("data", _data);
		return "/common/popup/mpso/masterMpSoPrewarhsngRequestDetailInfoPop";
	}
	
}
