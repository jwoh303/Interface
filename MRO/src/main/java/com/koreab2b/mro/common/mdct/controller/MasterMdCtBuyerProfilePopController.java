package com.koreab2b.mro.common.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdct.service.MasterMdCtBuyerProfilePopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtBuyerProfilePopController")
public class MasterMdCtBuyerProfilePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtBuyerProfilePopController.class);

	@Autowired
	private MasterMdCtBuyerProfilePopService masterMdCtBuyerProfilePopService;
	
	// 고객사 프로파일 팝업 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerProfilePopList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtBuyerProfilePopList(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		List<Map<String, String>> _data = masterMdCtBuyerProfilePopService.getList(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/masterMdCtBuyerProfilePop";
	}
	
	// 고객사 프로파일 매핑 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerProfileMappingList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerProfileMappingList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCtBuyerProfilePopService.getMappingList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 고객사 프로파일 방문일지 조회
	@RequestMapping(value = "/mdct/getMasterMdCtBuyerProfileCardList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtBuyerProfileCardList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		List<Map<String,String>> _data = masterMdCtBuyerProfilePopService.getCardList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 고객사 프로파일 등록
	@RequestMapping(value = "/mdct/regMasterMdCtBuyerProfilePopList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regMasterMdCtBuyerProfilePopList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
			Map<String, Object> _response = new HashMap<String, Object>();
			
			String _result = masterMdCtBuyerProfilePopService.regSelectedData(pMap);

			/* 성공시코드 OK , 실패시 메세지 전송 */
			_response.put("msg", _result);
			return _response;
	}
	
	// 고객사 프로파일 + 매핑 등록
	@RequestMapping(value = "/mdct/regAllMasterMdCtBuyerProfilePopList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regAllMasterMdCtBuyerProfilePopList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtBuyerProfilePopService.regAllSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 고객사 프로파일 영업Map 업로드
	@RequestMapping(value = "/mdct/addMasterMdCtBuyerProfileSalesImagePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addMasterMdCtBuyerProfileSalesImagePop(HttpServletRequest request, ModelMap pModel, @ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMdCtBuyerProfilePopService.addSalesImagePop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdct/masterMdCtBuyerProfileResultPop";

	}
	
	// 고객사 프로파일 조직도 업로드
	@RequestMapping(value = "/mdct/addMasterMdCtBuyerProfileOrgImagePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addMasterMdCtBuyerProfileOrgImagePop(HttpServletRequest request, ModelMap pModel, @ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMdCtBuyerProfilePopService.addOrgImagePop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdct/masterMdCtBuyerProfileResultPop";

	}
	
	// 고객사 프로파일 시스템프로세스 업로드
	@RequestMapping(value = "/mdct/addMasterMdCtBuyerProfileSysImagePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addMasterMdCtBuyerProfileSysImagePop(HttpServletRequest request, ModelMap pModel, @ModelAttribute("uploadForm") FileUploadForm uploadForm, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMdCtBuyerProfilePopService.addSysImagePop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdct/masterMdCtBuyerProfileResultPop";

	}
	
	// 고객사 프로파일 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtBuyerProfilePopList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtBuyerProfilePopList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
			Map<String, Object> _response = new HashMap<String, Object>();
			
			String _result = masterMdCtBuyerProfilePopService.saveSelectedData(pMap);

			/* 성공시코드 OK , 실패시 메세지 전송 */
			_response.put("msg", _result);
			return _response;
	}
	
	// 고객사 프로파일 + 매핑 저장
	@RequestMapping(value = "/mdct/saveAllMasterMdCtBuyerProfilePopList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveAllMasterMdCtBuyerProfilePopList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtBuyerProfilePopService.saveAllSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 고객사 프로파일 매핑 삭제
	@RequestMapping(value = "/mdct/delMasterMdCtBuyerProfileMappingList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delMasterMdCtBuyerProfileMappingList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdCtBuyerProfilePopService.delMappingData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	// 고객사 프로파일 재계약 등록
	@RequestMapping(value = "/mdct/regMasterMdCtBuyerReContractList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regMasterMdCtBuyerReContractList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
			Map<String, Object> _response = new HashMap<String, Object>();
			
			String _result = masterMdCtBuyerProfilePopService.regReContractData(pMap);

			/* 성공시코드 OK , 실패시 메세지 전송 */
			_response.put("msg", _result);
			return _response;
	}
}
