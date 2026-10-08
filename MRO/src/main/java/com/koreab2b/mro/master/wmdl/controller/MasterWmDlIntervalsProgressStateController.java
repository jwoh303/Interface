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
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.wmdl.service.MasterWmDlIntervalsProgressStateService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmDlIntervalsProgressStateController")
public class MasterWmDlIntervalsProgressStateController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlIntervalsProgressStateController.class);

	@Autowired
	private MasterWmDlIntervalsProgressStateService masterWmDlIntervalsProgressStateService;
	
	// 조회
	@RequestMapping(value = "/wmdl/getMasterWmDlIntervalsProgressStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmDlIntervalsProgressStateList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmDlIntervalsProgressStateService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/wmdl/excelMasterWmDlIntervalsProgressStateList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmDlIntervalsProgressStateService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/wmdl/saveMasterWmDlIntervalsProgressStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmDlIntervalsProgressState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		 
		String rtnMsg = masterWmDlIntervalsProgressStateService.updateSelectedData(formData, gridData);

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
	
	// 저장
	@RequestMapping(value = "/wmdl/saveMasterWmDlIntervalsProgressStatePop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmDlIntervalsProgressStatePop(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) {
//		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
//		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		String rtnMsg = masterWmDlIntervalsProgressStateService.updateSelectedPopData(pMap);

		_response.put("msg", rtnMsg);

		return  _response;
		
	}

	

	// 삭제
	@RequestMapping(value = "/wmdl/delMasterWmDlIntervalsProgressStateList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterWmDlIntervalsProgressState(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmDlIntervalsProgressStateService.delSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if("OK".equals(rtnMsg)){
			mp.put("Code",2);
		}else{
			mp.put("Code",3);
		}
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 조회
	@RequestMapping(value = "/wmdl/showMasterDlDelivCntPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterDlDelivCntPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
			logger.debug("/wmdl/showMasterDlDelivCntPop.do 요청 파라미터 for jsp : {}", pMap); 

			List<Map<String, String>> _data = masterWmDlIntervalsProgressStateService.getPopCnt(pMap);

			pModel.addAttribute("data", CommonUtil.getListNvl(_data));
			logger.debug("/wmdl/showMasterDlDelivCntPop.do 요청 파라미터 for jsp : {}", _data); 
		return "common/popup/wmdl/masterDlDelivCntPop";
	}
	

}
