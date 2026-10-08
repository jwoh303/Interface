package com.koreab2b.mro.common.mpvo.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.koreab2b.mro.common.mpvo.service.MasterMpVoVocBizGenerateStatePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocBizGenerateStatePopController")
public class MasterMpVoVocBizGenerateStatePopController {
	@Autowired
	private MasterMpVoVocBizGenerateStatePopService masterMpVoVocBizGenerateStatePopService;
	
	/**
	 * 사업팀 별 상세현황
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocBizGenerateStatePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocBizGenerateStatePop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		pMap.put("st_ds_dept_code", CommonUtil.nvl((String) pMap.get("st_ds_dept_code"), ""));
		pMap.put("st_recv_flag", CommonUtil.nvl((String) pMap.get("st_recv_flag"), ""));
		pMap.put("st_recv_type", CommonUtil.nvl((String) pMap.get("st_recv_type"), ""));
		pMap.put("st_ds_dept_name", CommonUtil.nvl((String) pMap.get("st_ds_dept_name"), ""));
		pMap.put("st_item_cnt", CommonUtil.nvl((String) pMap.get("st_item_cnt"), ""));
		pMap.put("st_ds_user_id", CommonUtil.nvl((String) pMap.get("st_ds_user_id"), ""));
		pMap.put("st_date_type", CommonUtil.nvl((String) pMap.get("st_date_type"), "WEEK"));
		pMap.put("st_date_flag", CommonUtil.nvl((String) pMap.get("st_date_flag"), "-14"));
		
		List<Map<String, String>> _data = masterMpVoVocBizGenerateStatePopService.getMasterMpVoVocBizGenerateStatePop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocBizGenerateStatePop";
	}
	
	/**
	 * 고객사 별 상세현황
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocBuyerGenerateStatePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocBuyerGenerateStatePop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		pMap.put("st_buyer_code", CommonUtil.nvl((String) pMap.get("st_buyer_code"), ""));
		pMap.put("st_recv_flag", CommonUtil.nvl((String) pMap.get("st_recv_flag"), ""));
		pMap.put("st_recv_type", CommonUtil.nvl((String) pMap.get("st_recv_type"), ""));
		pMap.put("st_buyer_name", CommonUtil.nvl((String) pMap.get("st_buyer_name"), ""));
		pMap.put("st_item_cnt", CommonUtil.nvl((String) pMap.get("st_item_cnt"), ""));
		pMap.put("st_sys_type", CommonUtil.nvl((String) pMap.get("st_sys_type"), ""));
		pMap.put("st_date_type", CommonUtil.nvl((String) pMap.get("st_date_type"), "WEEK"));
		pMap.put("st_date_flag", CommonUtil.nvl((String) pMap.get("st_date_flag"), "-14"));
		
		List<Map<String, String>> _data = masterMpVoVocBizGenerateStatePopService.getMasterMpVoVocBuyerGenerateStatePop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocBuyerGenerateStatePop";
	}
	
	/**
	 * 협력사 별 상세현황
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocAgntcmpyGenerateStatePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocAgntcmpyGenerateStatePop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		pMap.put("st_sys_type", CommonUtil.nvl((String) pMap.get("st_sys_type"), ""));
		pMap.put("st_agent_code", CommonUtil.nvl((String) pMap.get("st_agent_code"), ""));
		pMap.put("st_recv_flag", CommonUtil.nvl((String) pMap.get("st_recv_flag"), ""));
		pMap.put("st_recv_type", CommonUtil.nvl((String) pMap.get("st_recv_type"), ""));
		pMap.put("st_agent_name", CommonUtil.nvl((String) pMap.get("st_agent_name"), ""));
		pMap.put("st_item_cnt", CommonUtil.nvl((String) pMap.get("st_item_cnt"), ""));
		pMap.put("st_buyer_code", CommonUtil.nvl((String) pMap.get("st_buyer_code"), ""));
		pMap.put("st_date_type", CommonUtil.nvl((String) pMap.get("st_date_type"), "WEEK"));
		pMap.put("st_date_flag", CommonUtil.nvl((String) pMap.get("st_date_flag"), "-14"));
		
		List<Map<String, String>> _data = masterMpVoVocBizGenerateStatePopService.getMasterMpVoVocAgntcmpyGenerateStatePop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocAgntcmpyGenerateStatePop";
	}
}
