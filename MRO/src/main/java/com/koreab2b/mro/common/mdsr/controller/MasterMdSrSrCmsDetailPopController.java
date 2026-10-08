package com.koreab2b.mro.common.mdsr.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.mdsr.service.MasterMdSrSrCmsDetailPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdSrSrCmsDetailPopController")
public class MasterMdSrSrCmsDetailPopController {
	@Autowired
	private MasterMdSrSrCmsDetailPopService masterMdSrSrCmsDetailPopService;
	
	/**
	 * S/R 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdsr/getMasterMdSrSrCmsDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdSrSrCmsDetailPop(ModelMap pModel, @RequestParam Map<String, Object> pMap, HttpServletRequest pRequest) {
		String st_sr_user_id = CommonUtil.nvl((String) pMap.get("st_sr_user_id"), "");
		String st_sr_no = CommonUtil.nvl((String) pMap.get("st_sr_no"), "");
		
		SessionInfo _sessionInfo = (SessionInfo) pRequest.getSession().getAttribute("sessionInfo");
		String st_user_id = _sessionInfo.getUserId();
		
		pMap.put("st_user_id", st_user_id);
		pMap.put("st_sr_user_id", st_sr_user_id);
		pMap.put("st_sr_no", st_sr_no);
		List<Map<String, String>> _data = masterMdSrSrCmsDetailPopService.getMasterMdSrSrCmsDetailPop(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		pModel.addAttribute("st_sr_user_id", st_sr_user_id);
		pModel.addAttribute("st_sr_no", st_sr_no);
		return "common/popup/mdsr/masterMdSrSrCmsDetailPop";
	}
	
	/**
	 * ajax 처리 S/R 상세정보 update 처리
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdsr/saveMasterMdSrSrCmsDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdSrSrCmsDetailPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMdSrSrCmsDetailPopService.saveMasterMdSrSrCmsDetailPop(pMap);
		_response.put("msg", _result);
		return _response;
	}
	
	/**
	 * ajax 처리 S/R 상세정보 형상관리 처리
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdsr/historyMasterMdSrSrCmsDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> historyMasterMdSrSrCmsDetailPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMdSrSrCmsDetailPopService.historyMasterMdSrSrCmsDetailPop(pMap);
		_response.put("msg", _result);
		return _response;
	}
}
