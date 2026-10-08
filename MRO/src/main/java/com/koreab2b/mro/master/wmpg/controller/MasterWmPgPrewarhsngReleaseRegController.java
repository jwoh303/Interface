package com.koreab2b.mro.master.wmpg.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import com.koreab2b.mro.master.wmpg.service.MasterWmPgPrewarhsngReleaseRegService;
import com.koreab2b.mro.master.wmst.service.MasterWmStStockMovemntReleaseService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmPgPrewarhsngReleaseRegController")
public class MasterWmPgPrewarhsngReleaseRegController {

	@Autowired
	private MasterWmPgPrewarhsngReleaseRegService masterWmPgPrewarhsngReleaseRegService;
	
	@Autowired
	private MasterWmStStockMovemntReleaseService masterWmStStockMovemntReleaseService;
	
	// 조회
	@RequestMapping(value = "/wmpg/showMasterWmPgPrewarhsngReleaseReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String showMasterWmCoDelayPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());

		List<Map<String, String>> _data = masterWmStStockMovemntReleaseService.getWarehouseList(pMap);
		pModel.addAttribute("data", _data);

		return "master/wmpg/masterWmPgPrewarhsngReleaseRegList";
	}
	
	// 조회
	@RequestMapping(value = "/wmpg/getMasterWmPgPrewarhsngReleaseRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmPgPrewarhsngReleaseRegList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		String[] _st_buyer_code_array = null;
		
		_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		
		if ( _st_buyer_code_array.length == 1 && "".equals(CommonUtil.nvl(_st_buyer_code_array[0])) ) {
			_st_buyer_code_array = null;
		}
		
//		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
//			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
//		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterWmPgPrewarhsngReleaseRegService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/wmpg/excelMasterWmPgPrewarhsngReleaseRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		String[] _st_buyer_code_array = null;
		
		_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
		
		if ( _st_buyer_code_array.length == 1 && "".equals(CommonUtil.nvl(_st_buyer_code_array[0])) ) {
			_st_buyer_code_array = null;
		}
//		if ( String.valueOf(pMap.get("st_buyer_code")).indexOf("@") != -1 ) {
//			_st_buyer_code_array = String.valueOf(pMap.get("st_buyer_code")).split("@");
//		}
		
		pMap.put("buyer_code_array", _st_buyer_code_array);
		List<Map<String,String>> _data = masterWmPgPrewarhsngReleaseRegService.getList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/wmpg/saveMasterWmPgPrewarhsngReleaseRegList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterWmPgPrewarhsngReleaseReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterWmPgPrewarhsngReleaseRegService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}

	// 삭제
//	@RequestMapping(value = "/wmpg/delMasterWmPgPrewarhsngReleaseRegList.do", method = RequestMethod.POST)
//	@ResponseBody
//	public Map<String, Object> delMasterWmPgPrewarhsngReleaseReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
//		Map<String, Object> _response = new HashMap<String, Object>();
//		
//		// gridData
//		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
//		// formData
//		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
//		
//		String rtnMsg = masterWmPgPrewarhsngReleaseRegService.delSelectedData(formData, gridData);
//
//		/* 성공시코드 1 , 실패시 0 */
//		Map<String, Object> mp = new HashMap<String, Object>();
//		mp.put("Code",1);
//		_response.put("Result",mp);
//		_response.put("Message", rtnMsg);
//		return _response;
//	}

}
