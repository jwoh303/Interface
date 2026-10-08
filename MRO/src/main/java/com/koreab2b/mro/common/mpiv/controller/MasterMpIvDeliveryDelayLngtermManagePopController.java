package com.koreab2b.mro.common.mpiv.controller;

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

import com.koreab2b.mro.common.mpiv.service.MasterMpIvDeliveryDelayLngtermManagePopService;
import com.koreab2b.mro.util.CommonUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;

@Controller("masterMpIvDeliveryDelayLngtermManagePopController")
public class MasterMpIvDeliveryDelayLngtermManagePopController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMpIvDeliveryDelayLngtermManagePopController.class);

	@Autowired
	private MasterMpIvDeliveryDelayLngtermManagePopService masterMpIvDeliveryDelayLngtermManagePopService;
	
	/**
	 * 납품지연 장기건 관리 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mpiv/getMasterMpIvDeliveryDelayLngtermManagePop.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMpIvDeliveryDelayLngtermManagePop(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMpIvDeliveryDelayLngtermManagePopService.getList(pMap);
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
}
