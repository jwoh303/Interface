package com.koreab2b.mro.common.mprq.controller;

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
import com.koreab2b.mro.common.mprq.service.MasterMpRqDbStndrdProgressPopService;

@Controller("masterMpRqDbStndrdProgressPopController")
public class MasterMpRqDbStndrdProgressPopController {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpRqDbStndrdProgressPopController.class);

	@Autowired
	private MasterMpRqDbStndrdProgressPopService masterMpRqDbStndrdProgressPopService;
	
	/**
	 * DB표준화 진행 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/getMasterMpRqDbStndrdProgressPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpRqDbStndrdProgressPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		List<Map<String, String>> _data = masterMpRqDbStndrdProgressPopService.getList(pMap);
		_response.put("data", _data);
		
		return _response;
	}
	
	/**
	 * 이미지첨부
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mprq/addDbStndrdPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public String addDbStndrdPop(HttpServletRequest request, 
												ModelMap pModel, 
												@ModelAttribute("uploadForm") FileUploadForm uploadForm, 
												@RequestParam Map<String, String> pMap) {
		LOGGER.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.getCommonSesFrmData(request, pMap);
		
		String docNo = masterMpRqDbStndrdProgressPopService.addDbStndrdPop(uploadForm, pMap);
//		_response.put("data", _data);
		pModel.addAttribute("docNo", docNo);
		
		return "/common/popup/mprq/masterMpRqDbStndrdProgressResultPop";
		 
	}
	// 견적이관저장
	@RequestMapping(value = "/mprq/saveMasterMpRqCmsRecvDate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMpRqCmsRecvDate(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = masterMpRqDbStndrdProgressPopService.saveMasterMpRqCmsRecvDate(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
	}
	
}
