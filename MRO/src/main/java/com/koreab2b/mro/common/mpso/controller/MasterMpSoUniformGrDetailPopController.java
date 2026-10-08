package com.koreab2b.mro.common.mpso.controller;

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

import com.koreab2b.mro.common.mpso.service.MasterMpSoUniformGrDetailPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoUniformGrDetailPopController")
public class MasterMpSoUniformGrDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoUniformGrDetailPopController.class);

	@Autowired
	private MasterMpSoUniformGrDetailPopService masterMpSoUniformGrDetailPopService;
	
	/**
	 * 유니폼 선택  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpso/getMasterMpSoUniformGrDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpSoUniformGrDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpso/getMasterMpSoUniformGrDetailPop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data_hd = masterMpSoUniformGrDetailPopService.getHdList(pMap);
		List<Map<String, String>> _data_dt = masterMpSoUniformGrDetailPopService.getDtList(pMap);
		pModel.addAttribute("data_hd", CommonUtil.getListNvl(_data_hd));
		pModel.addAttribute("data_dt", CommonUtil.getListNvl(_data_dt));
		return "common/popup/mpso/masterMpSoUniformGrDetailPop";
	}
	
	/**
	 * 저장 
	 * 
	 */
	@RequestMapping(value = "/mpso/saveMasterMpSoUniformGrDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoUniformGrDetailPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger .debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userId", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String msg = masterMpSoUniformGrDetailPopService.updateSelectedData(pMap);
		
		msg  = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
