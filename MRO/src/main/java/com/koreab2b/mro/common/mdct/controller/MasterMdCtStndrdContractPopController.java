package com.koreab2b.mro.common.mdct.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mdct.service.MasterMdCtStndrdContractPopService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtStndrdContractPopController")
public class MasterMdCtStndrdContractPopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdCtStndrdContractPopController.class);

	@Autowired
	private MasterMdCtStndrdContractPopService masterMdCtStndrdContractPopService;
	
	/**
	 * 표준계약서 조회  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtStndrdContractPop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtStndrdContractPop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		
		List<Map<String,String>> _data = masterMdCtStndrdContractPopService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
