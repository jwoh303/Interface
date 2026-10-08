package com.koreab2b.mro.common.wmco.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmco.service.MasterWmCoGoodsCodePopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmCoGoodsCodePopController")
public class MasterWmCoGoodsCodePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmCoGoodsCodePopController.class);

	@Autowired
	private MasterWmCoGoodsCodePopService masterWmCoGoodsCodePopService;
	
	/**
	 * 품목코드 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmco/getMasterWmCoGoodsCodePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterWmCoGoodsCodePop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		List<Map<String,String>> _data = masterWmCoGoodsCodePopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("result","S"); 
		
		return "common/popup/"+pMap.get("codeGubun");
	}
	
}
