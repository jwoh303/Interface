package com.koreab2b.mro.master.mpiv.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonInfoService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpiv.service.MasterMpIvMkImScheduleRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMpIvMkImScheduleRegController")
public class MasterMpIvMkImScheduleRegController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvMkImScheduleRegController.class);

	@Autowired
	private CommonInfoService commonInfoService;

	@Autowired
	private MasterMpIvMkImScheduleRegService masterMpIvMkImScheduleRegService;

	/**
	 * 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getMasterMpIvMkImScheduleRegList.do", method = { RequestMethod.POST,
			RequestMethod.GET })
	public void getMasterMpIvMkImScheduleRegList(HttpServletRequest pReq, HttpServletResponse pRes,
			@RequestParam Map<String, Object> pMap) {
		logger.debug("/mpiv/getMasterMpIvMkImScheduleRegList.do 요청 파라미터 : {}", pMap);
		IBSheetUtil.removeSlash(pMap);
		pMap.put("paging", (pMap.get("onepagerow") != null) ? "1" : "0");
		List<Map<String, String>> _data = masterMpIvMkImScheduleRegService.getList(pMap);
		pReq.setAttribute("SHEETDATA", _data);

		new IBSheetUtil().getXml(pReq, pRes);
	}

	/**
	 * 수주접수 상세 조회
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/mpiv/getMasterMpIvMkImScheduleRegDetailPop.do", method = { RequestMethod.GET,
			RequestMethod.POST })
	public String getMasterMpIvMkImScheduleRegDetailPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mpiv/getMasterMpIvMkImScheduleRegDetailPop.do 요청 파라미터 for jsp : {}", pMap);
		List<Map<String, String>> _data = masterMpIvMkImScheduleRegService.getPopupList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		return "common/popup/mpiv/masterMpIvMkImScheduleRegDetailPop";
	}

	/**
	 * 일정등록
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpiv/saveMasterMkImScheduleReg.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMkImScheduleReg(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest request) {
		logger.debug("saveMkImScheduleReg 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		int _ret = masterMpIvMkImScheduleRegService.saveMkImScheduleReg(formData);
		_response.put("msg", _ret);
		logger.debug("_response " + _response);
		return _response;
	}

	/**
	 * 일정추가
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/mpiv/saveMasterMkImScheduleUpdate.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMkImScheduleUpdate(ModelMap pModel, @RequestParam Map<String, String> pMap,
			HttpServletRequest request) {
		logger.debug("saveMkImScheduleUpdate 요청 파라미터 : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> formData = CommonUtil.removeSlash(pMap);
		int rtnCnt = masterMpIvMkImScheduleRegService.saveMkImScheduleUpdate(formData);
		_response.put("msg", rtnCnt);
		logger.debug("_response " + _response);
		return _response;
	}

}
