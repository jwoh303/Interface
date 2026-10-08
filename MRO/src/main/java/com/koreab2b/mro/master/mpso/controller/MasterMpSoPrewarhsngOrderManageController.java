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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpso.service.MasterMpSoPrewarhsngOrderManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpSoPrewarhsngOrderManageController")
public class MasterMpSoPrewarhsngOrderManageController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpSoPrewarhsngOrderManageController.class);

	@Autowired
	private MasterMpSoPrewarhsngOrderManageService masterMpSoPrewarhsngOrderManageService;
	
	// 조회
	@RequestMapping(value = "/mpso/getMasterMpSoPrewarhsngOrderManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpSoPrewarhsngOrderManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMpSoPrewarhsngOrderManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mpso/excelMasterMpSoPrewarhsngOrderManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpSoPrewarhsngOrderManageService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

	// 선입고 요청 등록 및 수정
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngOrderManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngOrderManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 요청 취소
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngReqCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngReqCancel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatePrewarhsngReqCancel(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 관리 맵핑 등록(발주완료)
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngMappingReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngMappingReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatePrewarhsngMappingReg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 관리 맵핑 등록(부분발주완료)
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngMappingPartialReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngMappingPartialReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatePrewarhsngMappingPartialReg(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 관리 맵핑 취소(발주취소)
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngMappingCancelReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngMappingCancelReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatePrewarhsngMappingCancelReg(formData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 관리 다건 맵핑 취소(다건 발주 취소)
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngMappingGrpCancelReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpSoPrewarhsngMappingGrpCancelReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatePrewarhsngMappingGrpCancelReg(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 거래명세서
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngTranStatementReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatesaveMasterMpSoPrewarhsngTranStatementReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatesaveMasterMpSoPrewarhsngTranStatementReg(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	
	// 선입고 납품실적
	@RequestMapping(value = "/mpso/saveMasterMpSoPrewarhsngDeliveryEndReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatesaveMasterMpSoPrewarhsngDeliveryEndReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = masterMpSoPrewarhsngOrderManageService.updatesaveMasterMpSoPrewarhsngDeliveryEndReg(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

}
