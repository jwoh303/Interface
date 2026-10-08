package com.koreab2b.mro.master.wmst.controller;

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
import com.koreab2b.mro.master.wmst.service.MasterWmStStockManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmStStockManageController")
public class MasterWmStStockManageController {

	@Autowired
	private MasterWmStStockManageService masterWmStStockManageService;
	
	//데이터 조회
	@RequestMapping(value = "/wmst/getMasterWmStStockManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmStStockManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		// 페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmStStockManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}


	//데이터 저장
	@RequestMapping(value = "/wmst/saveMasterWmStStockManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmStStockManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmStStockManageService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	//데이터 삭제
	@RequestMapping(value = "/wmst/delMasterWmStStockManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmStStockManage(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmStStockManageService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 엑셀다운로드
	@RequestMapping(value = "/wmst/excelMasterWmStStockManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterWmStStockManageList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmStStockManageService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}

}
