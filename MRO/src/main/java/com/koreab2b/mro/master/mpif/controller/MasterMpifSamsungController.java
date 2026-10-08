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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mpif.service.MasterMpIfSamsungService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpifSamsungController")
public class MasterMpifSamsungController {

	@Autowired
	private MasterMpIfSamsungService masterMpIfSamsungService;

	// 조회
	@RequestMapping(value = "/mpif/getMasterMpifSamsungPoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMpifSamsungPoList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String deptCode = _sessionInfo.getDepartment();
		pMap.put("st_dept_code", deptCode);
		List<Map<String,String>> _data = masterMpIfSamsungService.getSamsungPoList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 엑셀다운로드
	@RequestMapping(value = "/mpif/excelMasterMpifSamsungPoList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMpifSamsungPoList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpIfSamsungService.getSamsungPoList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 저장
	@RequestMapping(value = "/mpif/saveMasterMpifSamsungPoReturn.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> savetMasterMpifSamsungPoReturn(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		 
		String rtnMsg = masterMpIfSamsungService.saveMasterMpifSamsungPoReturn(formData, gridData);
	
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
