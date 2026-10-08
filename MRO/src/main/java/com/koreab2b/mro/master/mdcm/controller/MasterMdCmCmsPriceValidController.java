package com.koreab2b.mro.master.mdcm.controller;

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
import com.koreab2b.mro.master.mdcm.service.MasterMdCmCmsPriceValidService;

@Controller("masterMdCmCmsPriceValidController")
public class MasterMdCmCmsPriceValidController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCmCmsPriceValidController.class);

	@Autowired
	private MasterMdCmCmsPriceValidService masterMdCmCmsPriceValidService;

	// 매입단가유효일 관리 - 목록 조회
	@RequestMapping(value = "/mdam/getMasterMdCmCmsPriceValidList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> searchMasterMdCmCmsPriceValidList(HttpServletRequest req, HttpServletResponse pRes, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		pMap = IBSheetUtil.removeSlash(pMap);

		List<Map<String,String>> _data = masterMdCmCmsPriceValidService.getList(pMap);

		req.setAttribute("SHEETDATA", _data);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
