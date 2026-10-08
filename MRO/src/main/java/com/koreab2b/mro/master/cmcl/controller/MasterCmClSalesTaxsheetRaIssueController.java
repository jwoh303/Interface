package com.koreab2b.mro.master.cmcl.controller;

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
import com.koreab2b.mro.master.cmcl.service.MasterCmClSalesTaxsheetRaIssueService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClSalesTaxsheetRaIssueController")
public class MasterCmClSalesTaxsheetRaIssueController {
	private Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private MasterCmClSalesTaxsheetRaIssueService pService;

	@RequestMapping(value = "/cmcl/getMasterCmClSalesTaxsheetRaIssueList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClSalesTaxsheetRaIssueList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = pService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	/**
	 * 전송FORMAT 2
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/cmcl/SendARMasterCmClSalesTaxsheetRaIssueFormat.do", method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> SendARMasterCmClSalesTaxsheetRaIssueFormat(ModelMap pModel, HttpServletRequest request,@RequestParam Map<String, Object> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		String flag = CommonUtil.getDevRealLocalFlag(request);		
		LOGGER.debug(" getSslURL 0 로컬 1 개발 2 운영 : {}", flag);
		if ("2".equals(flag)){
			pMap.put("smartBillUrl", "https://api.smartbill.co.kr/sb-api/request/");
		}else{
			pMap.put("smartBillUrl", "http://demoapi.smartbill.co.kr/sb-api/request/");
		}
		List<Map<String, String>> _data = pService.SendARMasterCmClSalesTaxsheetRaIssueFormat(pMap);
		
		
		LOGGER.debug("SEND_FORMAT" + _data.get(0).get("SEND_FORMAT"));
		
		
		_response.put("data", _data);
		return _response;
	}
	
	// 삭제
	@RequestMapping(value = "/cmcl/delMasterCmClSalesTaxsheetRaIssueRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterCmClSalesTaxsheetRaIssueReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = pService.delSelectedData(formData, gridData);
		
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClSalesTaxsheetRaIssueRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelRaList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = pService.getList(pMap);  
		IBSheetUtil.excelOut(req, res, CommonUtil.getListNvl(_data));
	}
}
