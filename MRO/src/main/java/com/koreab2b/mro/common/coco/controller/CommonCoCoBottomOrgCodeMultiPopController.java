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

import com.koreab2b.mro.common.coco.service.CommonCoCoBottomOrgCodeMultiPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoBottomOrgCodeMultiPopController")
public class CommonCoCoBottomOrgCodeMultiPopController {
	private static final Logger logger = LoggerFactory.getLogger(CommonCoCoBottomOrgCodeMultiPopController.class);
	
	@Autowired
	private CommonCoCoBottomOrgCodeMultiPopService commonCoCoBottomOrgCodeMultiPopService;
	
	/**
	 * 하위 조직 코드 정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoBottomOrgCodeMultiPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getCommonCoCoBottomOrgCodeMultiPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getCommonCoCoBottomOrgCodeMultiPop.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_buyer", CommonUtil.nvl((String)  pMap.get("st_buyer"),""));
		pMap.put("st_buyer_item_no", CommonUtil.nvl((String)  pMap.get("st_buyer_item_no"),""));
		pMap.put("st_agent", CommonUtil.nvl((String)  pMap.get("st_agent"),""));
		pMap.put("st_process_type", CommonUtil.nvl((String)  pMap.get("st_process_type"),""));
		pMap.put("st_org_code", CommonUtil.nvl((String)  pMap.get("st_org_code"),""));		
		pMap.put("st_nu_i", CommonUtil.nvl((String)  pMap.get("st_nu_i"),""));
		
		List<Map<String, String>> _data = commonCoCoBottomOrgCodeMultiPopService.getCommonCoCoBottomOrgCodeMultiPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/coco/commonCoCoBottomOrgCodeMultiPop";
	}
}
