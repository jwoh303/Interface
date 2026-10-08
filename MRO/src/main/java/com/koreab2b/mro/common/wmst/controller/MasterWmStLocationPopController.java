package com.koreab2b.mro.common.wmst.controller;

import java.util.ArrayList;
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

import com.koreab2b.mro.common.wmst.service.MasterWmStLocationPopService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterWmStLocationPopController")
public class MasterWmStLocationPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmStLocationPopController.class);

	@Autowired
	private MasterWmStLocationPopService masterWmStLocationPopService;
	
	/**
	 * 로케이션 변경 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/wmst/getMasterWmStLocationPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void getMasterWmStLocationPop(HttpServletRequest req, HttpServletResponse pRes ,@RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterWmStLocationPopService.getList(pMap);
//		return IBSheetUtil.addResut(req, _data , pMap);
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, pRes);	
	}
	
	
}
