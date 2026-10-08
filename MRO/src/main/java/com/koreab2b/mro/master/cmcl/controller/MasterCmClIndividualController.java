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
import com.koreab2b.mro.master.cmcl.service.MasterCmClIndividualService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterCmClIndividualController")
public class MasterCmClIndividualController {

	@Autowired
	private MasterCmClIndividualService masterCmClIndividualService;
	
	// 마감차수 조회 -- 마감차수 로직 변경 : 2014.07.31 (Upload, 분할만 사용중)
	@RequestMapping(value = "/cmcl/getMasterCmClIndividualList_getCloseMonthList.do",  method = {RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterCmClIndividualList_getCloseMonthList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>(); 
		
		List<Map<String,String>> _data = masterCmClIndividualService.getCloseMonthList(pMap);
		
		StringBuffer _optionStr = new StringBuffer();
		_optionStr.append("<select id='st_close_month' name='st_close_month' onChange='getBuyerGrAmt();'>\n");
		
		for( int i = 0; i < _data.size(); i++ ) {
			String _closeCnt = _data.get(i).get("CLOSE_CNT").trim();
			String _lastDate = _data.get(i).get("LAST_DATE").trim();
			
			if ( "1".equals( _closeCnt ) ) {
				_optionStr.append("<option value='"+_lastDate+"'>").append(_lastDate.substring(0,4)+"년 "+_lastDate.substring(4,6)+"월 "+"2차").append("</option>\n");
			}
			else if ( "3".equals( _closeCnt ) ) {
				_optionStr.append("<option value='"+_lastDate.substring(0,6)+"10'>").append(_lastDate.substring(0,4)+"년 "+_lastDate.substring(4,6)+"월 "+"1차").append("</option>\n");
				_optionStr.append("<option value='"+_lastDate.substring(0,6)+"20'>").append(_lastDate.substring(0,4)+"년 "+_lastDate.substring(4,6)+"월 "+"2차").append("</option>\n");
				_optionStr.append("<option value='"+_lastDate+"'>").append(_lastDate.substring(0,4)+"년 "+_lastDate.substring(4,6)+"월 "+"3차").append("</option>\n");
			}
			else {
				_optionStr.append("<option value='"+_lastDate.substring(0,6)+"15'>").append(_lastDate.substring(0,4)+"년 "+_lastDate.substring(4,6)+"월 "+"1차").append("</option>\n");
				_optionStr.append("<option value='"+_lastDate+"'>").append(_lastDate.substring(0,4)+"년 "+_lastDate.substring(4,6)+"월 "+"2차").append("</option>\n");
			}
		}
		
		_optionStr.append("</select>");
		
		_msg.put("MSG",  _optionStr); 
		_response.put("msg", _msg);
		
		return  _response;
	}
	
	// 조회
	@RequestMapping(value = "/cmcl/getMasterCmClIndividualList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClIndividualList(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClIndividualService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}
	@RequestMapping(value = "/cmcl/getMasterCmClIndividualList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterCmClIndividualList_v2(HttpServletRequest req, HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterCmClIndividualService.getList_v2(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/cmcl/excelMasterCmClIndividualList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterCmClIndividualService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	@RequestMapping(value = "/cmcl/excelMasterCmClIndividualList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList_v2(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterCmClIndividualService.getList_v2(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/cmcl/saveMasterCmClIndividualList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClIndividual(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClIndividualService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	@RequestMapping(value = "/cmcl/saveMasterCmClIndividualList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterCmClIndividual_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterCmClIndividualService.updateSelectedData_v2(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 삭제
//	@RequestMapping(value = "/cmcl/delMasterCmClIndividualList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> delMasterCmClIndividual(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		// formData
//		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
//		
//		String rtnMsg = masterCmClIndividualService.delSelectedData(formData, gridData);
//		_response.put("Message", rtnMsg);
//		
//		return _response;
//	}

}
