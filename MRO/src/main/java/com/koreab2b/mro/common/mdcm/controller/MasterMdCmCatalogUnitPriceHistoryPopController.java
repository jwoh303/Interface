package com.koreab2b.mro.common.mdcm.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.home.service.BuyerHomeGoodsRegFormPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdcm.service.MasterMdCmCatalogUnitPriceHistoryPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("MasterMdCmCatalogUnitPriceHistoryPopController")
public class MasterMdCmCatalogUnitPriceHistoryPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogUnitPriceHistoryPopController.class);

	@Autowired
	private MasterMdCmCatalogUnitPriceHistoryPopService masterMdCmCatalogUnitPriceHistoryPopService;

	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogUnitPriceHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogUnitPriceHistoryPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCmCatalogUnitPriceHistoryPopList 요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmCatalogUnitPriceHistoryPopService.getMasterMdCmCatalogUnitPriceHistoryPop(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
