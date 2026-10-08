package com.koreab2b.mro.common.mprq.controller;

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

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.service.MasterMpRqAddImgRegPopService;

@Controller("masterMpRqAddImgRegPopController")
public class MasterMpRqAddImgRegPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqAddImgRegPopController.class);

	@Autowired
	private MasterMpRqAddImgRegPopService masterMpRqAddImgRegPopService;
	
	/**
	 * 이미지등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/addImgRegPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addImgRegPop(HttpServletRequest request, 
												ModelMap pModel, 
												@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
												@RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMpRqAddImgRegPopService.addImgRegPop(uploadForm, pMap);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mprq/masterMpRqDbStndrdProgressResultPop";
		 
	}
	
}
