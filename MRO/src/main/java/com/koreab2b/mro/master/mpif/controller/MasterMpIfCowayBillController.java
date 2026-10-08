package com.koreab2b.mro.master.mpif.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpif.service.MasterMpIfCowayBillService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIfCowayBillController")
public class MasterMpIfCowayBillController {

	@Autowired
	private MasterMpIfCowayBillService masterMpIfCowayBillService;
	
	// 조회
	@RequestMapping(value = "/mpif/getMasterMpIfCowayBillList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpIfCowayBillAsList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		String delda	= ((String)pMap.get("st_yyyymm")).replaceAll("/", "");
		pMap.put("YYYYMM", delda);
		
		List<Map<String,String>> _data = masterMpIfCowayBillService.getMasterMpIfCowayBillList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mpif/excelMasterMpIfCowayBillList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void excelMasterMpIfCowayBillList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		
		String delda	= ((String)pMap.get("st_yyyymm")).replaceAll("/", "");
		pMap.put("YYYYMM", delda);
		
		List<Map<String,String>> _data = masterMpIfCowayBillService.getMasterMpIfCowayBillList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 전송
	@RequestMapping(value = "/mpif/sendMasterMpIfCowayBill.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sendMasterMpIfCowayBill(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		
		HashMap<String, String> tMap	= new HashMap<String, String>();
		tMap.put("", "");
		
		String rtnMsg = null;	//masterMpIfCowayBillService.sendMasterMpIfCowayBill(gridData);

		Map<String, Object> mp = new HashMap<String, Object>();
		// 성공시 : 1 실패시 : 0
		if ("SUCCESS".equals(rtnMsg)) {
			mp.put("Code",1);
		} else {
			mp.put("Code",0);
		}
		
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 삭제
//	@RequestMapping(value = "/mpif/delMasterMpIfCowayBillAsList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> delMasterMpIfCowayBillAsList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		
//		String rtnMsg = masterMpIfCowayBillService.delMasterMpIfCowayBillAsList(gridData);
//		
//		// 성공시 : 1 실패시 : 0
//		Map<String, Object> mp = new HashMap<String, Object>();
//		mp.put("Code",1);
//		_response.put("Result",mp);
//		_response.put("Message", rtnMsg);
//		return _response;
//	}
}
