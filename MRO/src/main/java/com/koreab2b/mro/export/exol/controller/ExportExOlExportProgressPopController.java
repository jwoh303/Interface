package com.koreab2b.mro.export.exol.controller;

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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.export.exol.service.ExportExOlExportProgressPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("exportExOlExportProgressPopController")
public class ExportExOlExportProgressPopController {

	private static final Logger logger = LoggerFactory.getLogger(ExportExOlExportProgressPopController.class);

	@Autowired
	private ExportExOlExportProgressPopService exportExOlExportProgressPopService;
	
	/**
	 * Lot 상세정보 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/getExportExOlExportProgressLotList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExOlExportProgressLotList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		List<Map<String,String>> _data = exportExOlExportProgressPopService.getLotList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * C/I, P/L 상세정보 팝업 상단 헤더
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/getExportExOlExportProgressCiData.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String searchExportExOlExportProgressCiData(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String, String>> _data = exportExOlExportProgressPopService.getCiData(pMap); 		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "export/exol/exportExOlExportProgressCiPop";
	}

	/**
	 * C/I, P/L 상세정보 팝업 하단 그리드
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/getExportExOlExportProgressCiList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExOlExportProgressCiList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExOlExportProgressPopService.getCiList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 * B/L 상세정보 팝업 상단 헤더
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/getExportExOlExportProgressBlData.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String searchExportExOlExportProgressBlData(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		List<Map<String, String>> _data = exportExOlExportProgressPopService.getBlData(pMap); 		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		
		return "export/exol/exportExOlExportProgressBlPop";
	}

	/**
	 * B/L 상세정보 팝업 하단 그리드
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/getExportExOlExportProgressBlList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExOlExportProgressBlList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExOlExportProgressPopService.getBlList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * C/I, P/L 상세정보 팝업 하단 그리드 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/saveExportExOlExportProgressCiList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExportExOlExportProgressCiList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = exportExOlExportProgressPopService.saveExportExOlExportProgressCiList(formData, gridData);
		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
}
