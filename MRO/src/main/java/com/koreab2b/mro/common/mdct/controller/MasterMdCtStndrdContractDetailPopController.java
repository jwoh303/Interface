package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mdct.service.MasterMdCtStndrdContractDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtStndrdContractDetailPopController")
public class MasterMdCtStndrdContractDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtStndrdContractDetailPopController.class);

	@Autowired
	private MasterMdCtStndrdContractDetailPopService masterMdCtStndrdContractDetailPopService;
	
	/**
	 * 표준계약서 조회 상세  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showMasterMdCtStndrdContractDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtStndrdContractDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getMasterMdCtStndrdContractDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		Map<String, String> _data = masterMdCtStndrdContractDetailPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getMapNvl(_data)); 
		return "common/popup/mdct/masterMdCtStndrdContractDetailPop";
	}
	
	// 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtStndrdContractDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtStndrdContractDetailPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/deleteMasterMdCtStndrdContractDetailPop.do Map 요청 파라미터 : formData {}", pMap); 

		String flag = masterMdCtStndrdContractDetailPopService.deleteSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
	
}
