package com.koreab2b.mro.master.mdct.controller;

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
import com.koreab2b.mro.master.mdct.service.MasterMdCtReportSalesPopService;
import com.koreab2b.mro.util.CommonUtil;



@Controller("masterMdCtReportSalesPopController")
public class MasterMdCtReportSalesPopController {
	
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtReportSalesPopController.class);
	
	@Autowired
	private MasterMdCtReportSalesPopService masterMdCtReportSalesPopService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesPopList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtReportSalesPopList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getList(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 부서조회
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesPopDeptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesPopDeptList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtReportSalesPopDeptList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getDeptList(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 입력 조회
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesTotalList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesTotalList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtReportSalesPopList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesTotalList(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtReportSalesPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportSalesPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.updateSelectedData(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtReportCustomerList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtReportCustomerList(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.deleteMasterMdCtReportCustomerList(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 신규계약 품목 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesNewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesNewPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtReportSalesPopList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesNewPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 신규계약 품목 입력 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesNewInputPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesNewInputPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtReportSalesPopList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesNewInputPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 신규계약 품목 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtReportSalesNewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportSalesNewPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.saveMasterMdCtReportSalesNewPop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 신규계약 품목 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtReportSalesNewPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtReportSalesNewPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.deleteMasterMdCtReportSalesNewPop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// sg 품목별 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesSgPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesSgPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesSgPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// sg 품목별 입력 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesSgInputPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesSgInputPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesSgInputPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// sg 품목별 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtReportSalesSgPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportSalesSgPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.saveMasterMdCtReportSalesSgPop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// sg 품목별 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtReportSalesSgPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtReportSalesSgPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.deleteMasterMdCtReportSalesSgPop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	//카테고리 품목별 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesCaPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesCaPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesCaPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 카테고리 품목별 입력 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesCaInputPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesCaInputPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesCaInputPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 카테고리 품목별 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtReportSalesCaPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportSalesCaPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.saveMasterMdCtReportSalesCaPop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 카테고리 품목별 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtReportSalesCaPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtReportSalesCaPop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.deleteMasterMdCtReportSalesCaPop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	//납기견적 관리 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesDeRePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesDeRePop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesDeRePop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	//납기견적 관리 입력 조회 
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesDeReInputPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtReportSalesDeReInputPop(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesDeReInputPop(pMap);			
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	//납기견적 관리 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtReportSalesDeRePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportSalesDeRePop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.saveMasterMdCtReportSalesDeRePop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	//납기견적 관리 삭제
	@RequestMapping(value = "/mdct/deleteMasterMdCtReportSalesDeRePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> deleteMasterMdCtReportSalesDeRePop(HttpServletRequest req, ModelMap pModel, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtReportSalesPopService.deleteMasterMdCtReportSalesDeRePop(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	// 총평조회
	@RequestMapping(value = "/mdct/getMasterMdCtReportSalesEvaluationPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtReportSalesEvaluationPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesEvaluationPop(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/masterMdCtReportSalesEvaluationPop";
	}
	// 총평조회
	@RequestMapping(value = "/mdct/saveMasterMdCtReportSalesEvaluationPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtReportSalesEvaluationPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		LOGGER.debug("요청 파라미터 : {}", pMap);
		String rtnMsg = masterMdCtReportSalesPopService.saveMasterMdCtReportSalesEvaluationPop(pMap);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	// 거래현황상세 고객사별 엑셀다운로드
	@RequestMapping(value = "/mdct/excelMasterMdCtReportSalesPopList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCtReportSalesPopList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
	
	// 거래현황상세 부서별 엑셀다운로드
	@RequestMapping(value = "/mdct/excelMasterMdCtReportSalesPopDeptList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCtReportSalesPopDeptList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getDeptList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
	
	// sg 품목별 절감현황 엑셀다운로드
	@RequestMapping(value = "/mdct/excelMasterMdCtReportSalesSgPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCtReportSalesSgPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesSgPop(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
	
	// 카테고리 품목별 절감현황 엑셀다운로드
	@RequestMapping(value = "/mdct/excelMasterMdCtReportSalesCaPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelMasterMdCtReportSalesCaPop(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCtReportSalesPopService.getMasterMdCtReportSalesCaPop(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
}
