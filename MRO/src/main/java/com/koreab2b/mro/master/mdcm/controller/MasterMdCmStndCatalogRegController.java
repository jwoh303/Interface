package com.koreab2b.mro.master.mdcm.controller;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmStndCatalogRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmStndCatalogRegController")
public class MasterMdCmStndCatalogRegController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndCatalogRegController.class);

	@Autowired
	private MasterMdCmStndCatalogRegService masterMdCmStndCatalogRegService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmStndCatalogRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterMdCmStndCatalogRegList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmStndCatalogRegService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmStndCatalogRegList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCmStndCatalogRegList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){

		List<Map<String,String>> _data = masterMdCmStndCatalogRegService.getList(pMap); 
		IBSheetUtil.excelOut(req, res, _data);
		 
	}
	
	// 생성
	@RequestMapping(value = "/mdcm/saveMasterMdCmStndCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmStndCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("updateMasterMdCmStndCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmStndCatalogRegService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/mdcm/delMasterMdCmStndCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmStndCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCmStndCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmStndCatalogRegService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 파일업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmStndCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmStndCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmStndCatalogReg MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmStndCatalogRegService.batchSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 임시저장
	@RequestMapping(value = "/mdcm/saveTempMasterMdCmStndCatalogRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveTempMasterMdCmStndCatalogRegList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("saveTempMasterMdCmStndCatalogRegList MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmStndCatalogRegService.saveTempMasterMdCmStndCatalogRegList(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

	// 생성
	@RequestMapping(value = "/mdcm/saveMasterMdCmStndCatalogRegPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmStndCatalogRegPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmStndCatalogRegService.saveMasterMdCmStndCatalogRegPop(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	//등록품의 팝업
	@RequestMapping(value = "/mdcm/saveMasterMdCmStndCatalogApprPop", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmStndCatalogApprPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		Map<String,String> _result = masterMdCmStndCatalogRegService.saveMasterMdCmStndCatalogApprPop(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	//등록품의
	@RequestMapping(value = "/mdcm/saveMasterMdCmStndCatalogApprList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmStndCatalogApprList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		Map<String,String> _result = masterMdCmStndCatalogRegService.saveMasterMdCmStndCatalogApprList(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}

}
