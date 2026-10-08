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
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogMappingService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogMappingController")
public class MasterMdCmCatalogMappingController {

	@Autowired
	private MasterMdCmCatalogMappingService masterMdCmCatalogMappingService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogMappingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogMappingList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterMdCmCatalogMappingService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCatalogMappingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogMappingService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	/*품목매핑*/
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCatalogMapping(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterMdCmCatalogMappingService.saveMasterMdCmCatalogMapping(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/*반려*/
	@RequestMapping(value = "/mdcm/rejectMasterMdCmCatalogMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectMasterMdCmCatalogMapping(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogMappingService.rejectMasterMdCmCatalogMapping(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/*매핑완료*/
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogMappingCompl.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCatalogMappingCompl(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogMappingService.saveMasterMdCmCatalogMappingCompl(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/*매핑삭제*/
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogMappingDel.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmCatalogMappingDel(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogMappingService.saveMasterMdCmCatalogMappingDel(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/*매핑요청*/
	@RequestMapping(value = "/mdcm/saveMasterMdcmReqMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdcmReqMapping(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogMappingService.saveMasterMdcmReqMapping(formData, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	/*품목보완 요청*/
	@RequestMapping(value = "/mdcm/saveMasterMdCmReqAgentCatalog.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmReqAgentCatalog(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		Map<String, String> formData2 = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = masterMdCmCatalogMappingService.saveMasterMdCmReqAgentCatalog(formData,formData2, gridData);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 비고저장
	@RequestMapping(value = "/mdcm/saveMasterMdcmReqRemarkAtos.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdcmReqRemarkAtos(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = masterMdCmCatalogMappingService.saveMasterMdcmReqRemarkAtos(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
	}
	// 카테고리 속성검색
	@RequestMapping(value = "/mdcm/getMasterMdCmCategoriAttb.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCategoriAttb(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMdCmCatalogMappingService.getMasterMdCmCategoriAttb(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	// 품목정비 요청 이력팝업	
	@RequestMapping(value = "/mdcm/getCmsComplementHistoryPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCmsComplementHistoryPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCmCatalogMappingService.getCmsComplementHistoryPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
