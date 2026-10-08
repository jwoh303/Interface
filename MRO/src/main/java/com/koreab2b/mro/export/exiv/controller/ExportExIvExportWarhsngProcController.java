package com.koreab2b.mro.export.exiv.controller;

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
import com.koreab2b.mro.export.exiv.service.ExportExIvExportWarhsngProcService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("exportExIvExportWarhsngProcController")
public class ExportExIvExportWarhsngProcController {

	private static final Logger logger = LoggerFactory.getLogger(ExportExIvExportWarhsngProcController.class);

	@Autowired
	private ExportExIvExportWarhsngProcService exportExIvExportWarhsngProcService;
	
	/**
	 * 입고등록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/getExportExIvExportWarhsngProcList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExIvExportWarhsngProcList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExIvExportWarhsngProcService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 입고등록 엑셀다운로드
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/exiv/excelExportExIvExportWarhsngProcList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExIvExportWarhsngProcService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
	/**
	 * 입고번호(거래명세서상세) 상세 입고등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/saveExportExIvExportWarhsngProc.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExportExIvExportWarhsngProc(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExIvExportWarhsngProcService.updateSelectedHdData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/**
	 * 입고번호(거래명세서상세) 상세 입고등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/saveExportExIvExportWarhsngProcList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateExportExIvExportWarhsngProc(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExIvExportWarhsngProcService.updateSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/**
	 * 입고번호(거래명세서상세) 조회(sheet , detail)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/getExportExIvExportWarhsngProcDetail.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getExportExIvExportWarhsngProcDetail(ModelMap pModel, @RequestParam Map<String, Object> pMap) {
		logger.debug("commonList 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String, String>> _data = exportExIvExportWarhsngProcService.getDetail(pMap);
		
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		logger.debug("보낸값 for jsp : {}", pModel); 
		
		// 화면에서 보낸값에 의한 화면 전환
		return "common/popup/exiv/exportExIvExportWarhsngProcDetail";
	}
	/**
	 * 거래명세서번호 조회(sheet , detail)
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/getExportExIvExportWarhsngProcDetailData.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getExportExIvExportWarhsngProcDetailData(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = exportExIvExportWarhsngProcService.getDetailData(pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	/**
	 * 입고등록 상세 엑셀다운로드
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/exiv/excelExportExIvExportWarhsngProcDetail.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void excelExportExIvExportWarhsngProcDetail(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExIvExportWarhsngProcService.getDetailList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
}
