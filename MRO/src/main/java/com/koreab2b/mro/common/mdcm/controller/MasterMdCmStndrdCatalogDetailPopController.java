package com.koreab2b.mro.common.mdcm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdcm.service.MasterMdCmStndrdCatalogDetailPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCmStndrdCatalogDetailPopController")
public class MasterMdCmStndrdCatalogDetailPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmStndrdCatalogDetailPopController.class);

	@Autowired
	private MasterMdCmStndrdCatalogDetailPopService masterMdCmStndrdCatalogDetailPopService;
	
	/**
	 * 표준카탈로그 상세보기  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdcm/getMasterMdCmStndrdCatalogDetailPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCmStndrdCatalogDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdcm/getMasterMdCmStndrdCatalogDetailPop.do 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = masterMdCmStndrdCatalogDetailPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("st_cms_catlg_id", pMap.get("st_cms_catlg_id"));
		
		return "common/popup/mdcm/masterMdCmStndrdCatalogDetailPop";
	}	 
	
	// 저장
	@RequestMapping(value = "/mdcm/saveMasterMdCmStndrdCatalogDetailPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCmStndrdCatalogDetailPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		logger.debug("saveMasterMdCmStndrdCatalogDetailPop MultiValueMap 요청 파라미터 : formData", pMap); 
		String rtnMsg = masterMdCmStndrdCatalogDetailPopService.updateSelectedData(pMap);

		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/**
	 * 이미지 등록/수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/addMasterMdCmStndCatalogAlterPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addMasterMdCmStndCatalogAlterPop(HttpServletRequest request, 
												ModelMap pModel, 
												@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
												@RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMdCmStndrdCatalogDetailPopService.addMasterMdCmStndCatalogAlterPop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdcm/masterMdCmStndrdCatalogDetailResultPop";

	}
	/**
	 * 이미지 상세 등록/수정
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mdcm/addMasterMdCmStndCatalogAlterDetailPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addMasterMdCmStndCatalogAlterDetailPop(HttpServletRequest request, 
												ModelMap pModel, 
												@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
												@RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMdCmStndrdCatalogDetailPopService.addMasterMdCmStndCatalogAlterDetailPop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mdcm/masterMdCmStndrdCatalogDetailResultPop";

	}
	
}
