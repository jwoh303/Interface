package com.koreab2b.mro.master.mpso.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpso.service.MasterMpSoPayRegMngService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("masterMpSoPayRegMngController")
public class MasterMpSoPayRegMngController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoPayRegMngController.class);

	@Autowired
	private MasterMpSoPayRegMngService masterMpSoPayRegMngService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoPayRegMngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpSoPayRegMngList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMpSoPayRegMngService.getMasterMpSoPayRegMngList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
		
	// 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoPayRegMngList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpSoPayRegMngList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");		 
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("st_user_id",_sessionInfo.getUserId());
		 
		String rtnMsg = masterMpSoPayRegMngService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 삭제
	@RequestMapping(value = "/mpso/deleteMasterMpSoPayRegMngList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterMpSoPayRegMngList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");		 
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		formData.put("st_user_id",_sessionInfo.getUserId());
		 
		String rtnMsg = masterMpSoPayRegMngService.deleteSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}	
	
	
	// 예정일 변경 팝업
	@RequestMapping(value = "/mpso/getMasterMpSoChangeSchdCloseMMPop.do", method = RequestMethod.POST)
	public String getMasterMpSoChangeSchdCloseMMPop(ModelMap pModel, HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, String> pMap) {
		pModel.addAllAttributes(pMap);
		return "/common/popup/mpso/masterMpSoSchdCloseMMPop";
	}
	
	// 예정일 변경 사유 저장
	@RequestMapping(value = "/mpso/saveMasterMpSoPayRegMngRemarkPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMpSoPayRegMngRemarkPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();	
		
		String rtnMsg = masterMpSoPayRegMngService.saveRemark(pMap);
		
		_response.put("msg", rtnMsg);
		return _response;
		
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelMasterMpSoPayRegMngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoPayRegMngService.getMasterMpSoPayRegMngList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	

	//  품의 상신 
	@RequestMapping(value = "/mpso/approvalMasterMpSoPayRegMngList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approvalMasterMpSoPayRegMngList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);		
		
		String rtnMsg = masterMpSoPayRegMngService.approvalSelectedData(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;

	}
	
	
}
