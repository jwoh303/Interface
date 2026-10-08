package com.koreab2b.mro.master.clmg.controller;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.clmg.service.MasterClMgCreditBuyerListService;

@Controller("masterClMgCreditBuyerListController")
public class MasterClMgCreditBuyerListController {

	private static final Logger logger = LoggerFactory.getLogger(MasterClMgCreditBuyerListController.class);

	@Autowired
	private MasterClMgCreditBuyerListService masterClMgCreditBuyerListService;
	
	// 조회
	@RequestMapping(value = "/clmg/getMasterClMgCreditBuyerList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	public void searchMasterClMgCreditBuyerList(HttpServletRequest req , HttpServletResponse res, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		
		List<Map<String,String>> _data = masterClMgCreditBuyerListService.getList(pMap);
		
		req.setAttribute("SHEETDATA", _data);
		new IBSheetUtil().getXml(req, res);	
	}
}
