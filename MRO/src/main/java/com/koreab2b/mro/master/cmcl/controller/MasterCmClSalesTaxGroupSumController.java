package com.koreab2b.mro.master.cmcl.controller;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClSalesTaxGroupSumService;
import com.koreab2b.mro.util.CommonUtil;


@Controller("masterCmClSalesTaxGroupSumController")
public class MasterCmClSalesTaxGroupSumController {

	@Autowired
	private MasterCmClSalesTaxGroupSumService masterCmClSalesTaxGroupSumService;
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClSalesTaxGroupSumList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClSalesTaxGroupSumList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterCmClSalesTaxGroupSumService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClSalesTaxGroupSumList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterCmClSalesTaxGroupSumService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClSalesTaxGroupSumList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterCmClSalesTaxGroupSumList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClSalesTaxGroupSumService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}


}
