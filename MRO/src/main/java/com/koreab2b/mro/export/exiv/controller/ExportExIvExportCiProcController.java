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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.export.exiv.service.ExportExIvExportCiProcService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("exportExIvExportCiProcController")
public class ExportExIvExportCiProcController {

	private static final Logger logger = LoggerFactory.getLogger(ExportExIvExportCiProcController.class);

	@Autowired
	private ExportExIvExportCiProcService exportExIvExportCiProcService;
	
	/**
	 *  CI 등록 대상 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/getExportExIvExportCiProcList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExIvExportCiProcList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExIvExportCiProcService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 *  CI Item 추가등록 대상 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/exiv/getExportExIvExportCiItemList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getExportExIvExportCiItemList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = exportExIvExportCiProcService.getItemList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	/**
	 * 입고번호(거래명세서상세) 상세 입고등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/saveExportExIvExportCiProc.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExportExIvExportCiProc(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExIvExportCiProcService.updateSelectedHdData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/**
	 * CI 등록 상세 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/getExportExIvExportCiProcDetail.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getExportExIvExportCiProcDetail(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = exportExIvExportCiProcService.getDetailData(pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	/**
	 * 반품조회 팝업 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/getExportExIvIcomCodPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getExportExIvIcomCodPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExIvExportCiProcService.getExportExIvIcomCodPop(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);  
	}
	/**
	 * C/L, P/L 등록
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/saveExportExIvExportReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExportExIvExportReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExIvExportCiProcService.updateSelectedData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	/**
	 * 입고취소
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exiv/cancleExportExIvExportReceipt.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> cancleExportExIvExportReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExIvExportCiProcService.cancleExportExIvExportReceipt(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
	// CI번호 체크
	@RequestMapping(value = "/exiv/getExportExIvExporCICheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getExportExIvExporCICheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = exportExIvExportCiProcService.getCICheck(pMap);
			
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	

	/*엑셀다운로드*/
	@RequestMapping(value = "/exiv/excelExportExIvExportCiProcList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExIvExportCiProcService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
}
