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

import com.koreab2b.mro.common.coco.service.CommonCoCoCatalogAlterPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("commonCoCoCatalogAlterPopController")
public class CommonCoCoCatalogAlterPopController {
	
private static final Logger logger = LoggerFactory.getLogger(CommonCoCoCatalogAlterPopController.class);
	
	@Autowired
	private CommonCoCoCatalogAlterPopService commonCoCoCatalogAlterPopService;
	
	// 조회
	@RequestMapping(value = "/coco/getCommonCoCoCatalogAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonCoCoCatalogAlterPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("/coco/getCommonCoCoCatalogAlterPop.do 요청 파라미터 for jsp : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] arrayMaker = ((String) pMap.get("st_maker_name_field")).split("/");
		String[] arrayDescription = ((String) pMap.get("st_description_field")).split("/");
		String[] arraySpecification = ((String) pMap.get("st_specification_field")).split("/");
		pMap.put("RESULT_IN_DESCRIPTION", arrayDescription);
		pMap.put("RESULT_IN_SPECIFICATION", arraySpecification);
		pMap.put("RESULT_IN_MAKER", arrayMaker);
		
		List<Map<String,String>> _data = commonCoCoCatalogAlterPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
