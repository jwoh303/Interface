package com.koreab2b.mro.common.coco.controller;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.coco.service.CommonCoCoStndrdCatalogSearchPopService;

@Controller("commonCoCoStndrdCatalogSearchPopController")
public class CommonCoCoStndrdCatalogSearchPopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoStndrdCatalogSearchPopController.class);
	
	@Autowired
	private CommonCoCoStndrdCatalogSearchPopService commonCoCoStndrdCatalogSearchPopService;
	
	/**
	 * 표준카달로그검색(CMS)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoStndrdCatalogSearchPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoStndrdCatalogSearchPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/coco/getCommonCoCoStndrdCatalogSearchPop.do 요청 파라미터 for jsp : {}", pMap);
		
		return "common/popup/coco/commonCoCoStndrdCatalogSearchPop";
	}
}
