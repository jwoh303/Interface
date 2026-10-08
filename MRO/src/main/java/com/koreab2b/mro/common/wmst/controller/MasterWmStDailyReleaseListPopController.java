package com.koreab2b.mro.common.wmst.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.wmst.service.MasterWmStDailyReleaseListPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmStDailyReleaseListPopController")
public class MasterWmStDailyReleaseListPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmStDailyReleaseListPopController.class);

	@Autowired
	private MasterWmStDailyReleaseListPopService masterWmStDailyReleaseListPopService;
	
	/**
	 * 일일 입출고 List 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStDailyReleaseList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterWmStDailyReleaseList(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		
		List<Map<String,String>> _data = masterWmStDailyReleaseListPopService.getList(pMap);
		//return IBSheetUtil.addResut(req, _data , pMap);
		for(Integer i=0 ; i< _data.size(); i++){
			Integer rowCount = i+1;
			_data.get(i).put("ROWSEQ", rowCount.toString());
		}
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	
	// 엑셀다운로드
	@RequestMapping(value = "/wmst/excelMasterWmStDailyReleaseList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){

		
		//페이징용 파라미터의 셋팅
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);
		
		List<Map<String,String>> _data = masterWmStDailyReleaseListPopService.getExcelList(pMap);
		for(Integer i=0 ; i< _data.size(); i++){
			Integer rowCount = i+1;
			_data.get(i).put("ROWSEQ", rowCount.toString());
		}
		req.setAttribute("SHEETDATA", _data);
		IBSheetUtil.excelOut(req, res, _data);
	}
	
}
