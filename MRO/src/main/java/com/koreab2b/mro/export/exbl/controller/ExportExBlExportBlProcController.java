package com.koreab2b.mro.export.exbl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.export.exbl.service.ExportExBlExportBlProcService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("exportExBlExportBlProcController")
public class ExportExBlExportBlProcController {

	private static final Logger logger = LoggerFactory.getLogger(ExportExBlExportBlProcController.class);

	@Autowired
	private ExportExBlExportBlProcService exportExBlExportBlProcService;
	
	/**
	 *  BL등록 대상 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exbl/getExportExBlExportBlProcList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExBlExportBlProcList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExBlExportBlProcService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * BL등록 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exbl/getExportExBlExportBlProcDetail.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getExportExBlExportBlProcDetail(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = exportExBlExportBlProcService.getDetailData(pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	/**
	 * B/L 등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exbl/saveExportExBlExportReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExportExBlExportReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExBlExportBlProcService.updateSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
