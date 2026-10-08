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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogRegProgressService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogRegProgressController")
public class MasterMdCmCatalogRegProgressController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCatalogRegProgressController.class);

	@Autowired
	private MasterMdCmCatalogRegProgressService masterMdCmCatalogRegProgressService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogRegProgressList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCatalogRegReqList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmCatalogRegProgressService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);	
	}
	
	// 취소
	@RequestMapping(value = "/mdcm/delMasterMdCmCatalogRegProgressList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmCatalogRegProgress(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("delMasterMdCmCatalogRegProgress MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegProgressService.delSelectedData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 소싱변경 업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogRegSourcingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogRegSourcing(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmCatalogRegSourcing MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegProgressService.batchSourcingData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 판가변경 업로드
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogRegUnitPriceList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogRegUnitPrice(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("batchMasterMdCmCatalogRegUnitPrice MultiValueMap 요청 파라미터 : formData", formData); 
		String rtnMsg = masterMdCmCatalogRegProgressService.batchUnitPriceData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mprq/excelMasterMdCmCatalogRegProgressList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogRegProgressService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
	
	// 재소싱요청
	@RequestMapping(value = "/mdcm/saveMasterMdCmCatalogRegReSourcingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmCatalogRegReSourcing(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCmCatalogRegProgressService.updateReSourcingData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
		
	}
	
	// 카탈로그 등록차수 팝업 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogRegRevisionPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogRegRevisionPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogRegProgressService.getMasterMdCmCatalogRegRevisionList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 소싱제출, 판가제출 품의 상신
	@RequestMapping(value = "/mdcm/sendMasterMdCmCatalogReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendMasterMdCmCatalogReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		logger.debug("요청 파라미터 : gridData", gridData);
		logger.debug("consMasterMpRqItemReqStnd MultiValueMap 요청 파라미터 : formData", formData); 
		Map<String,String> _result = masterMdCmCatalogRegProgressService.updateData(formData, gridData);

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
