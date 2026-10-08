package com.koreab2b.mro.common.mpvo.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.controller.MasterMpRqBuyerQuotationReceiptSendCntPopController;
import com.koreab2b.mro.common.mpvo.service.MasterMpVoVocProgressStateFBPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpVoVocProgressStatePopFBController")
public class MasterMpVoVocProgressStateFBPopController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqBuyerQuotationReceiptSendCntPopController.class);
	
	@Autowired
	private MasterMpVoVocProgressStateFBPopService masterMpVoVocProgressStatePopFBService;
	
	/**
	 * VOC 진행현황 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocProgressStatePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocProgressStatePop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"), ""));
		pMap.put("st_vc_no", CommonUtil.nvl((String) pMap.get("st_vc_no"), ""));
		List<Map<String, String>> _data = masterMpVoVocProgressStatePopFBService.getMasterMpVoVocProgressStatePop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocProgressStatePop";
	}
	
	/**
	 * VOC 진행현황(FB) 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocProgressStateFBPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocProgressStateFBPop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"), ""));
		pMap.put("st_vc_no", CommonUtil.nvl((String) pMap.get("st_vc_no"), ""));
		List<Map<String, String>> _data = masterMpVoVocProgressStatePopFBService.getMasterMpVoVocProgressStateFBPop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocProgressStateFBPop";
	}
	
	/**
	 * VOC 진행현황(FB Change) 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocProgressStateFbChangePop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMpVoVocProgressStateFbChangePop(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		pMap.put("st_buyer", CommonUtil.nvl((String) pMap.get("st_buyer"), ""));
		pMap.put("st_vc_no", CommonUtil.nvl((String) pMap.get("st_vc_no"), ""));
		List<Map<String, String>> _data = masterMpVoVocProgressStatePopFBService.getMasterMpVoVocProgressStatePop(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mpvo/masterMpVoVocProgressStateFbChangePop";
	}
	
	/**
	 * ajax 처리 VOC 진행현황 처리 담당자 변경
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpvo/saveMasterMpVoVocDsUserInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpVoVocDsUserInfo(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpVoVocProgressStatePopFBService.saveMasterMpVoVocDsUserInfo(pMap);
		_response.put("msg", _result);
		return _response;
	}
	
	/**
	 * ajax 처리 VOC 진행현황 Feedback 처리
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpvo/saveMasterMpVoVocProgressStatePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpVoVocProgressStatePop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_user_id",_sessionInfo.getUserId());
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpVoVocProgressStatePopFBService.saveMasterMpVoVocProgressStatePop(pMap);
		_response.put("msg", _result);
		return _response;
	}
	
	/**
	 * ajax 처리 VOC 진행현황(FB Change) 저장
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpvo/saveMasterMpVoVocProgressStateFbChangePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpVoVocProgressStateFbChangePop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpVoVocProgressStatePopFBService.saveMasterMpVoVocProgressStateFbChangePop(pMap);
		_response.put("msg", _result);
		return _response;
	}
	
	/**
	 * ajax 처리  VOC차수 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/getMasterMpVoVocHistPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpVoVocHistPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpVoVocProgressStatePopFBService.getMasterMpVoVocHistPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * ajax처리 VOC차수 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpvo/saveVocRevisionPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> saveMasterMpVoVocHistPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, String> _response = new HashMap<String, String>();
		if(masterMpVoVocProgressStatePopFBService.saveVocRevisionPop(pMap) == 1) { // 차수 테이블에 저장이 완료되었을 시
			String _result = masterMpVoVocProgressStatePopFBService.updateVocRevisionPop(pMap);
			_response.put("msg", _result);
		}
		return _response;
	}
	/**
	 * ajax 처리 VOC 중간저장
	 * @param req
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpvo/saveMasterMpVoVocProgressPCPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpVoVocProgressPCPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_session_user_id",_sessionInfo.getUserId());
		
		Map<String, Object> _response = new HashMap<String, Object>();
		String _result = masterMpVoVocProgressStatePopFBService.saveMasterMpVoVocProgressPCPop(pMap);
		_response.put("msg", _result);
		return _response;
	}
}
