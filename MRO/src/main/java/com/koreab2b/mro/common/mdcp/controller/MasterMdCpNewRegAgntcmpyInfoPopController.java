package com.koreab2b.mro.common.mdcp.controller;

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
import com.koreab2b.mro.common.mdcp.service.MasterMdCpNewRegAgntcmpyInfoPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCpNewRegAgntcmpyInfoPopController")
public class MasterMdCpNewRegAgntcmpyInfoPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCpNewRegAgntcmpyInfoPopController.class);

	@Autowired
	private MasterMdCpNewRegAgntcmpyInfoPopService masterMdCpNewRegAgntcmpyInfoPopService;
	
	/**
	 * 신규등록 협력사 정보  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcp/showMasterMdCpNewRegAgntcmpyInfoPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCpNewRegAgntcmpyInfoPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcp/getMasterMdCpNewRegAgntcmpyInfoPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCpNewRegAgntcmpyInfoPopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		
		return "common/popup/mdcp/masterMdCpNewRegAgntcmpyInfoPop";
	}
	
	// 조회
	@RequestMapping(value = "/mdcp/getMasterMdCpNewRegAgntcmpyInfoPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCpNewRegAgntcmpyInfoPopList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdCpNewRegAgntcmpyInfoPopService.getCmpyList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// Mdm 담당자 Check
	@RequestMapping(value = "/mdcp/getMdmCheckMasterMdCpNewRegAgntcmpyInfoPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getMdmCheckMasterMdCpNewRegAgntcmpyInfoPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		logger.debug("getMdmCheckMasterMdCpNewRegAgntcmpyInfoPop Map 요청 파라미터 : formData", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdCpNewRegAgntcmpyInfoPopService.getMdmList(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdcp/updateMasterMdCpNewRegAgntcmpyInfoPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCpNewRegAgntcmpyInfoPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		System.out.println("Controller Call");
		
		logger.debug("updateMasterMdCpNewRegAgntcmpyInfoPop Map 요청 파라미터 : formData {}", pMap); 
		String rtnMsg = masterMdCpNewRegAgntcmpyInfoPopService.updateSelectedData(pMap);
		
		_response.put("msg", rtnMsg);
		return _response;
	}
}
