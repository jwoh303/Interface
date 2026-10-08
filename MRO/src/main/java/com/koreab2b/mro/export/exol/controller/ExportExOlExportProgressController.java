package com.koreab2b.mro.export.exol.controller;

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
import com.koreab2b.mro.export.exol.service.ExportExOlExportProgressService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("exportExOlExportProgressController")
public class ExportExOlExportProgressController {

	private static final Logger logger = LoggerFactory.getLogger(ExportExOlExportProgressController.class);

	@Autowired
	private ExportExOlExportProgressService exportExOlExportProgressService;
	
	/**
	 * 외자납품 관리 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/getExportExOlExportProgressList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchExportExOlExportProgressList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExOlExportProgressService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	/**
	 * 외자납품 관리 엑셀다운로드
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/exiv/excelExportExOlExportProgressList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = exportExOlExportProgressService.getList(pMap);
		IBSheetUtil.excelOut(req,res,_data);
	}
	
	/**
	 * 저장, 납품완료
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/saveExportExOlExportProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveExportExOlExportProgress(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExOlExportProgressService.updateSelectedHdData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	/**
	 * CI, PL 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/delCiExportExOlExportProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delCiExportExOlExportProgress(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExOlExportProgressService.updateSelectedCiData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
	
	/**
	 * BL 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/exol/delBlExportExOlExportProgress.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBlExportExOlExportProgress(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object>_list = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> _pMap = CommonUtil.getMultiValueMapMap(pMap);
		logger.debug("요청 파라미터 : _list", _list);
		
		String rtnMsg = exportExOlExportProgressService.updateSelectedBlData(_pMap, _list);
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
	}
}
