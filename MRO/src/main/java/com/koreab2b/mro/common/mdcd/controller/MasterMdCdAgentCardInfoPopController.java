package com.koreab2b.mro.common.mdcd.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdcd.service.MasterMdCdAgentCardInfoPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCdAgentCardInfoPopController")
public class MasterMdCdAgentCardInfoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCdAgentCardInfoPopController.class);

	@Autowired
	private MasterMdCdAgentCardInfoPopService masterMdCdAgentCardInfoPopService;
	
	/**
	 * 고객카드정보  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcd/showMasterMdCdAgentCardInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCdAgentCardInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcd/getMasterMdCdAgentCardInfoPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCdAgentCardInfoPopService.getList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdcd/masterMdCdAgentCardInfoPop";
	}	 
	
	// 조회
	@RequestMapping(value = "/mdcd/getMasterMdCdAgentCardInfoPopVisit.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCdAgentCardInfoPopVisit(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String, String>> _visitData = masterMdCdAgentCardInfoPopService.getVisitList(pMap);

		return IBSheetUtil.addResut(req, _visitData , pMap);
	}
	
	// 삭제
	@RequestMapping(value = "/mdcd/deleteMasterMdCdAgentCardInfoPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMdCdAgentCardInfoPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData {}", gridData);
		logger.debug("deleteMasterMdCdAgentCardInfoPop MultiValueMap 요청 파라미터 : formData {} ", formData); 

		String rtnMsg = masterMdCdAgentCardInfoPopService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */

		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
