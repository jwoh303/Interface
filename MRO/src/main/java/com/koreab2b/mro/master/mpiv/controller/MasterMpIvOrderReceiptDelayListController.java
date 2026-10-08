package com.koreab2b.mro.master.mpiv.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mpiv.service.MasterMpIvOrderReceiptDelayListService;

@Controller("masterMpIvOrderReceiptDelayListController")
public class MasterMpIvOrderReceiptDelayListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvOrderReceiptDelayListController.class);

	@Autowired
	private MasterMpIvOrderReceiptDelayListService masterMpIvOrderReceiptDelayListService;
	
	// 조회
	@RequestMapping(value = "/mpiv/getMasterMpIvOrderReceiptDelayList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public void searchMasterMpIvOrderReceiptDelayList(HttpServletRequest pReq, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		// 조회일 슬래시 제거
		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterMpIvOrderReceiptDelayListService.getList(pMap);

		pReq.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(pReq, pRes);
		
//		return IBSheetUtil.addResut(req, _data , pMap);
	}

}
