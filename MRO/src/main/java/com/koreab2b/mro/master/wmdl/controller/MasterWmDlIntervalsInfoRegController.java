package com.koreab2b.mro.master.wmdl.controller;

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
import com.koreab2b.mro.master.wmdl.service.MasterWmDlIntervalsInfoRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmDlIntervalsInfoRegController")
public class MasterWmDlIntervalsInfoRegController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlIntervalsInfoRegController.class);

	@Autowired
	private MasterWmDlIntervalsInfoRegService masterWmDlIntervalsInfoRegService;
	
	// 조회
	@RequestMapping(value = "/wmdl/getMasterWmDlIntervalsInfoRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmDlIntervalsInfoRegList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmDlIntervalsInfoRegService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 조회
	@RequestMapping(value = "/wmdl/getMasterWmDlIntervalsInfoRegAllList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmDlIntervalsInfoRegAllList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmDlIntervalsInfoRegService.getAllList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/wmdl/excelMasterWmDlIntervalsInfoRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmDlIntervalsInfoRegService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/wmdl/saveMasterWmDlIntervalsInfoRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmDlIntervalsInfoReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmDlIntervalsInfoRegService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){
			
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/wmdl/delMasterWmDlIntervalsInfoRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmDlIntervalsInfoReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmDlIntervalsInfoRegService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){
			
			mp.put("Code",3);
		}else{
			mp.put("Code",4);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}

}
