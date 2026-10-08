package com.koreab2b.mro.master.wmdl.controller;

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
import com.koreab2b.mro.master.wmdl.service.MasterWmDlBuyerWarhsngService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterWmDlBuyerWarhsngController")
public class MasterWmDlBuyerWarhsngController {

	private static final Logger logger = LoggerFactory.getLogger(MasterWmDlBuyerWarhsngController.class);

	@Autowired
	private MasterWmDlBuyerWarhsngService masterWmDlBuyerWarhsngService;
	
	// 조회
	@RequestMapping(value = "/wmdl/getMasterWmDlBuyerWarhsngList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterWmDlBuyerWarhsngList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterWmDlBuyerWarhsngService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}


}
