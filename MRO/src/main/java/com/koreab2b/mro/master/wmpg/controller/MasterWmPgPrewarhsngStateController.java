package com.koreab2b.mro.master.wmpg.controller;

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
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmpg.service.MasterWmPgPrewarhsngStateService;
import com.koreab2b.mro.master.wmst.service.MasterWmStStockMovemntReleaseService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmPgPrewarhsngStateController")
public class MasterWmPgPrewarhsngStateController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmPgPrewarhsngStateController.class);
	
	@Autowired
	private MasterWmStStockMovemntReleaseService masterWmStStockMovemntReleaseService;

	@Autowired
	private MasterWmPgPrewarhsngStateService masterWmPgPrewarhsngStateService;
	
	@RequestMapping(value = "/wmpg/showMasterWmPgPrewarhsngState.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String showMasterWmPgPrewarhsngState(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());

		List<Map<String, String>> _data = masterWmStStockMovemntReleaseService.getWarehouseList(pMap);
		pModel.addAttribute("data", _data);
		return "master/wmpg/masterWmPgPrewarhsngStateList";
	}
	
	// 조회
	@RequestMapping(value = "/wmpg/getMasterWmPgPrewarhsngStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmPgPrewarhsngStateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmPgPrewarhsngStateService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/wmpg/excelMasterWmPgPrewarhsngStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmPgPrewarhsngStateService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// 저장
	@RequestMapping(value = "/wmpg/deleteMasterWmPgPrewarhsngState.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteMasterWmPgPrewarhsngState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmPgPrewarhsngStateService.deleteMasterWmPgPrewarhsngState(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
		
}
