package com.koreab2b.mro.common.coco.controller;

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

import com.koreab2b.mro.common.coco.service.CommonCoCoCurrencyPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("commonCoCoCurrencyPopController")
public class CommonCoCoCurrencyPopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoCurrencyPopController.class);
	
	@Autowired
	private CommonCoCoCurrencyPopService commonCoCoCurrencyPopService;
	
	/**
	 * 품목별 환율 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	

	@RequestMapping(value = "/coco/getCommonCoCoCurrencyPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoCurrencyPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = commonCoCoCurrencyPopService.getCommonCoCoCurrencyPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
