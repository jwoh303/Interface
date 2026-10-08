package com.koreab2b.mro.master.clmg.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.clmg.service.MasterClMgCreditCmpyPopService;

@Controller("masterClMgCreditCmpyPopController")
public class MasterClMgCreditCmpyPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterClMgCreditCmpyPopController.class);

	@Autowired
	private MasterClMgCreditCmpyPopService masterClMgCreditCmpyPopService;
	
	/**
	 * 여신한도 고객사코드 매핑리스트
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/clmg/getMasterClMgCreditCmpyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqQuotationUnitpriceHistoryPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterClMgCreditCmpyPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
		
}
