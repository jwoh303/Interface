package com.koreab2b.mro.common.coco.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.coco.service.CommonCoCoBottomOrgCodePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoBottomOrgCodePopController")
public class CommonCoCoBottomOrgCodePopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBottomOrgCodePopController.class);
	
	@Autowired
	private CommonCoCoBottomOrgCodePopService commonCoCoBottomOrgCodePopService;
	
	/**
	 * 하위 조직 코드 정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBottomOrgCodePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBottomOrgCodePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBottomOrgCodePop.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_buyer_item_no", CommonUtil.nvl((String)  pMap.get("st_buyer_item_no"),""));
		pMap.put("st_gubun", CommonUtil.nvl((String)  pMap.get("st_gubun"),"N"));
		pMap.put("st_nu_i", CommonUtil.nvl((String)  pMap.get("st_nu_i"),""));
		
		List<Map<String, String>> _data = commonCoCoBottomOrgCodePopService.getCommonCoCoBottomOrgCodePop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/coco/commonCoCoBottomOrgCodePop";
	}
}
