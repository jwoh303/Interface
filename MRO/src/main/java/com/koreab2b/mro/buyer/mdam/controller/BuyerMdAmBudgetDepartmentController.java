package com.koreab2b.mro.buyer.mdam.controller;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmBudgetDepartmentService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmBudgetDepartmentController")
public class BuyerMdAmBudgetDepartmentController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmBudgetDepartmentController.class);

	@Autowired
	private BuyerMdAmBudgetDepartmentService buyerMdAmBudgetDepartmentService;
	
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetDepartmentListAll_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmBudgetDepartmentListAll_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getBuyerMdAmBudgetDepartmentList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = buyerMdAmBudgetDepartmentService.getBuyerMdAmBudgetDepartmentListAll_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetDepartmentList.do", method = RequestMethod.POST)
	public String getBuyerMdAmBudgetDepartmentList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		//logger.debug("/mdam/getBuyerMdAmBudgetDepartmentList.do 요청 파라미터 : {}", pMap);

		// 페이징처리
		pMap = CommonUtil.PagingPrc2(pMap);
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		// 화면 조회
		List<Map<String, String>> _data = buyerMdAmBudgetDepartmentService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "buyer/mdam/buyerMdAmBudgetDepartmentList";
	}
	@RequestMapping(value = "/mdam/getBuyerMdAmBudgetDepartmentList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmBudgetDepartmentList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("getBuyerMdAmBudgetDepartmentList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
			pMap.put("SESSION_BUSINESS_COND", _sessionInfo.getBusinessCond());
		}
		
		List<Map<String,String>> _data = buyerMdAmBudgetDepartmentService.getBuyerMdAmBudgetDepartmentList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	//삭제
	@RequestMapping(value = "/mdam/delBuyerMdAmBudgetDepartmentList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMdAmBudgetDepartmentList_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmBudgetDepartmentService.delBuyerMdAmBudgetDepartmentList_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("삭제하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	//저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetDepartmentList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmBudgetDepartmentList_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmBudgetDepartmentService.saveBuyerMdAmBudgetDepartmentList_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("저장하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetDepartmentList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmBudgetDepartment(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdam/saveBuyerMdAmBudgetDepartmentList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		_pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		
		String flag = buyerMdAmBudgetDepartmentService.updateSelectedData(_pMap, _list);
		_response.put("msg", flag);

		return  _response;
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/mdam/excelBuyerMdAmBudgetDepartmentList.do", method = RequestMethod.POST)
	public void excelBuyerMdAmBudgetDepartment(ModelMap pModel, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		//logger.debug("/mdam/excelBuyerMdAmBudgetDepartmentList.do 요청 파라미터 for jsp : {}", pMap);
		
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = buyerMdAmBudgetDepartmentService.getList(pMap); 
		   
		logger.debug("getExcelDown 요청 파라미터 for jsp : _data.size()  {}", _data.size());
		String headers = "";

		CommonUtil.downloadExcel(_data, response, outputStream, headers);
		 
	}
	@RequestMapping(value = "/mdam/showBuyerMdAmDepartmentListPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmDepartmentListPop_v2(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		return "buyer/mdam/buyerMdAmDepartmentListPop_v2";
	}
	
	@RequestMapping(value = "/mdam/saveBuyerMdAmDepartmentListPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmDepartmentListPop_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmBudgetDepartmentService.saveBuyerMdAmDepartmentListPop_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("저장하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	@RequestMapping(value = "/mdam/delBuyerMdAmBudgetDepartmentConList_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBuyerMdAmBudgetDepartmentConList_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmBudgetDepartmentService.delBuyerMdAmBudgetDepartmentConList_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("삭제하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	@RequestMapping(value = "/mdam/showBuyerMdAmBudgetDepartmentListPop_v2.do", method = { RequestMethod.GET, RequestMethod.POST })
	public String showBuyerMdAmBudgetDepartmentListPop_v2(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		return "buyer/mdam/buyerMdAmBudgetDepartmentListPop_v2";
	}
	
	@RequestMapping(value = "/mdam/saveBuyerMdAmBudgetDepartmentListPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveBuyerMdAmBudgetDepartmentListPop_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		String rtnMsg = buyerMdAmBudgetDepartmentService.saveBuyerMdAmBudgetDepartmentListPop_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		if(rtnMsg.equals("저장하였습니다.")){
			mp.put("Code",1);
		}else{
			mp.put("Code",0);
		}
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
}
