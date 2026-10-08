package com.koreab2b.mro.common.mprq.controller;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqStndrdCatalogSearchPopService;

@Controller("masterMpRqStndrdCatalogSearchPopController")
public class MasterMpRqStndrdCatalogSearchPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqStndrdCatalogSearchPopController.class);

	@Autowired
	private MasterMpRqStndrdCatalogSearchPopService masterMpRqStndrdCatalogSearchPopService;
	
	/**
	 * 표준 카탈로그 검색  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqStndrdCatalogSearchPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqStndrdCatalogSearchPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpRqStndrdCatalogSearchPopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
