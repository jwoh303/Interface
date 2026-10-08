package com.koreab2b.mro.common.mpso.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mpso.service.MasterMpSoPrewarhsngRequestOrderMapppingPopService;

@Controller("masterMpSoPrewarhsngRequestOrderMapppingPopController")
public class MasterMpSoPrewarhsngRequestOrderMapppingPopController {

	@Autowired
	private MasterMpSoPrewarhsngRequestOrderMapppingPopService masterMpSoPrewarhsngRequestOrderMapppingPopService;
	
	/**
	 * 선입고요청 발주매핑 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpso/getMasterMpSoPrewarhsngRequestOrderMapppingPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoPrewarhsngRequestOrderMapppingPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoPrewarhsngRequestOrderMapppingPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
