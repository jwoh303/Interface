package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.common.mdct.service.MasterMdCtStndrdContractWritePopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtStndrdContractWritePopController")
public class MasterMdCtStndrdContractWritePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtStndrdContractWritePopController.class);

	@Autowired
	private MasterMdCtStndrdContractWritePopService masterMdCtStndrdContractWritePopService;
	
	/**
	 * 표준계약서 작성  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showMasterMdCtStndrdContractWritePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtStndrdContractWritePop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getMasterMdCtStndrdContractWritePop.do 요청 파라미터 for jsp : {}", pMap);
		
		pMap.put("st_form_no", CommonUtil.nvl(pMap.get("st_form_no"), ""));

		Map<String, String> _data = masterMdCtStndrdContractWritePopService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getMapNvl(_data)); 
		return "common/popup/mdct/masterMdCtStndrdContractWritePop";
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtStndrdContractWritePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtStndrdContractWritePop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_user_name", _sessionInfo.getUserNameLoc() );

		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/saveMasterMdCtStndrdContractWritePop.do Map 요청 파라미터 : formData {} ", pMap); 

		String flag = masterMdCtStndrdContractWritePopService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	
}
