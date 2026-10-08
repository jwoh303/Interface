package com.koreab2b.mro.common.mdcp.controller;

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
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mdcp.service.MasterMdCpPrivateInfoAlterPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpPrivateInfoAlterPopController")
public class MasterMdCpPrivateInfoAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpPrivateInfoAlterPopController.class);

	@Autowired
	private MasterMdCpPrivateInfoAlterPopService masterMdCpPrivateInfoAlterPopService;
	
	/**
	 * 개인정보 수정  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/getMasterMdCpPrivateInfoAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpPrivateInfoAlterPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpPrivateInfoAlterPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCpPrivateInfoAlterPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcp/masterMdCpPrivateInfoAlterPop";
	}	 
	
}
