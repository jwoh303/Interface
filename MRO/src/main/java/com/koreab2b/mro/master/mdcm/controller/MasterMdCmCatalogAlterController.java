package com.koreab2b.mro.master.mdcm.controller;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCatalogAlterService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmCatalogAlterController")
public class MasterMdCmCatalogAlterController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMdCmCatalogAlterController.class);

	@Autowired
	private MasterMdCmCatalogAlterService masterMdCmCatalogAlterService;
	
	// 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogAlterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCatalogAlterList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
//		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String[] arrayMaker = ((String) pMap.get("st_maker_name_field")).split("/");
		String[] arrayDescription = ((String) pMap.get("st_description_field")).split("/");
		String[] arraySpecification = ((String) pMap.get("st_specification_field")).split("/");
		pMap.put("RESULT_IN_DESCRIPTION", arrayDescription);
		pMap.put("RESULT_IN_SPECIFICATION", arraySpecification);
		pMap.put("RESULT_IN_MAKER", arrayMaker);
		
		String byca_comorg_code = masterMdCmCatalogAlterService.getBycaComorgSelect(pMap);
		pMap.put("BYCA_COMORG_CODE", byca_comorg_code);
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCatalogAlterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		String byca_comorg_code = masterMdCmCatalogAlterService.getBycaComorgSelect(pMap);
		pMap.put("BYCA_COMORG_CODE", byca_comorg_code);
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getExcelList(pMap);
		
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// MSDS 조회
	@RequestMapping(value = "/mdcm/getMasterMsdsList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void searchMasterMsdsList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.geMsdstList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	/**
	 * MSDS 상세조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMsdsDetailList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMsdsDetailList(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.geMsdsDetailList(pMap);
		List<Map<String,String>> _hdata = masterMdCmCatalogAlterService.geMsdsHeadDetailList(pMap);
		pModel.addAttribute("data", _data);
		pModel.addAttribute("hdata", _hdata);
		return "common/popup/coco/commonCoCoMsdsDetailPop";
	}
	@RequestMapping(value = "/mdcm/getMasterMsdsDetailList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMsdsDetailList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getMasterMsdsDetailList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * MSDS 상세등록  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMsdsRegList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMsdsRegList(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.geMsdsRegList(pMap);
		pModel.addAttribute("data", _data);
		return "common/popup/coco/commonCoCoMsdsDetailRegPop";
	}
	/**
	 *  MSDS매핑하기
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterMsdsMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMsdsMapping(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMdCmCatalogAlterService.saveMasterMsdsMapping(formData, gridData);
		_response.put("resultFlag", flag);
		
		return _response;
	}
	/**
	 *  MSDS BYIT 매핑하기
	 * @param pReq
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterMsdsByitMapping.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMsdsByitMapping(HttpServletRequest pReq, @RequestParam MultiValueMap<String, String> pMap) {
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		int flag = masterMdCmCatalogAlterService.saveMasterMsdsByitMapping(formData, gridData);
		_response.put("resultFlag", flag);
		
		return _response;
	}
	/**
	 * MSDS 상세조회  삭제
	 */
	@RequestMapping(value = "/mdcm/delMasterMsdsDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMsdsDetailList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMdCmCatalogAlterService.delMasterMsdsDetailList(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * MSDS 상세조회  수정
	 */
	@RequestMapping(value = "/mdcm/updateMasterMsdsDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMsdsDetailList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMdCmCatalogAlterService.updateMasterMsdsDetailList(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	/**
	 * MSDS 상세등록
	 */
	@RequestMapping(value = "/mdcm/insertMasterMsdsDetailList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertMasterMsdsDetailList(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("userid", _sessionInfo.getUserId()); // 사용자ID TEST	
		pMap.put("buyer", _sessionInfo.getComCode() );
		
		
		String msg = masterMdCmCatalogAlterService.insertMasterMsdsDetailList(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 조회 - 일괄카탈로그 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogMultiAlter.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogMultiAlter(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getMasterMdCmCatalogMultiAlter(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 조회- 카탈로그 계약변경 일괄수정 화면에서 물류센터코드 조회
	@RequestMapping(value = "/mdcm/getWarehouseCodeList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, String> getWarehouseCodeList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getWarehouseCodeList(pMap);
		Map<String, String> text1 = _data.get(0);
		
		return text1;
	}
	
	
	// 조회 - 카탈로그조회 팝업 (기존카탈로그)
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogExistingAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST}) 
	public String getMasterMdCmCatalogExistingAlterPop(ModelMap pModel  ,HttpServletRequest req ,@RequestParam Map<String, String> pMap) {	
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getMasterMdCmCatalogSearchPop(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdcm/masterMdCmCatalogExistingAlterPop";
	}
	
	// 카탈로그조회 등록 일괄 (엑셀업로드)
	@RequestMapping(value = "/mdcm/batchMasterMdCmCatalogMultiAlter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> batchMasterMdCmCatalogMultiAlter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("batchMasterMdCmCatalogMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCmCatalogAlterService.batchMasterMdCmCatalogMultiAlter(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	// 카탈로그조회 등록 일괄 (팝업에서)
	@RequestMapping(value = "/mdcm/popBatchMasterMdCmCatalogMultiAlter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> popBatchMasterMdCmCatalogMultiAlter(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		 
		 
		LOGGER.debug("popBatchMasterMdCmCatalogMultiAlter pMap  요청 파라미터 : pMap {} ", pMap); 
		String msg = masterMdCmCatalogAlterService.popBatchMasterMdCmCatalogMultiAlter(pMap);

		msg = "OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	
	// 카탈로그조회 삭제
	@RequestMapping(value = "/mdcm/delMasterMdCmCatalogMultiAlter.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCmCatalogMultiAlter(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData", gridData);
		LOGGER.debug("delMasterMdCmCatalogMultiAlter MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCmCatalogAlterService.delMasterMdCmCatalogMultiAlter(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	// 카탈로그 일괄 등록 품의 상신
	@RequestMapping(value = "/mdcm/requestMasterMdCmCatalogSearchPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> requestMasterMdCmCatalogSearchPop(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) { 
		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		LOGGER.debug("요청 파라미터 : gridData  {} ", gridData);
		LOGGER.debug("requestMasterMdCmCatalogSearchPop MultiValueMap 요청 파라미터 : formData  {} ", formData); 
		String rtnMsg = masterMdCmCatalogAlterService.requestMasterMdCmCatalogSearchPop(formData, gridData);
		
		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	
	// 카탈로그 일괄 등록 품의 결재완료
	public String approvalMasterMdCmCatalogSearchPop(Map<String, String> pMap) { 
		  
		LOGGER.debug("approvalMasterMdCmCatalogSearchPop Map 요청 파라미터 : pMap  {} ", pMap); 
		String rtnMsg = masterMdCmCatalogAlterService.approvalMasterMdCmCatalogSearchPop(pMap);
		
		return rtnMsg;
	}
	
	// 결재정보 조회
	@RequestMapping(value = "/mdcm/getMasterMdCmCatalogApprInfoPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCmCatalogApprovalInformationPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) { 
		
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getApprInfoList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 고객사 카탈로그 수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/saveMasterMdCmBuyerCatalogStatus.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmBuyerCatalogStatus(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		
		Map<String,String> _result = masterMdCmCatalogAlterService.saveSelectedStatusData(formData, gridData);

		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("msg", _result.get("MSG"));
		mp.put("usrmsg",_result.get("PM_NO"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	// 표준카테고리 엑셀다운로드
	@RequestMapping(value = "/mdcm/excelMasterMdCmCmsCatalogAlterList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void cmsExcelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap	){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdCmCatalogAlterService.getCmsExcelList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
	// MSDS 매핑 해제
	@RequestMapping(value = "/mdcm/saveMasterMdCmBuyerCatalogMsdsClean.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCmBuyerCatalogMsdsClean(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		//LOGGER.debug("요청 파라미터 : gridData", gridData);
		//LOGGER.debug("saveMasterMdCmBuyerCatalogMsdsClean MultiValueMap 요청 파라미터 : formData  {} ", formData);
		
		String rtnMsg = masterMdCmCatalogAlterService.saveSelectedMsdsClean(formData, gridData);
		
		/* Code 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
