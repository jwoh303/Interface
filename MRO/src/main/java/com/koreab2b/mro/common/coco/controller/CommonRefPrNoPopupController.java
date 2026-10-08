package com.koreab2b.mro.common.coco.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.MapUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.buyer.mpso.service.BuyerMpSoExternalService;
import com.koreab2b.mro.common.coco.service.CommonRefPrNoPopupService;
import com.koreab2b.mro.common.ibsheet.IBSheetResponseUtil;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.common.mprq.service.BuyerMpRqQuotationNegoHistoryPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonRefPrNoPopupController")
public class CommonRefPrNoPopupController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonRefPrNoPopupController.class);

	@Autowired
	private CommonRefPrNoPopupService commonRefPrNoPopupService;

	
	@RequestMapping(value = "/common/buyerRefPrNoPopList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> buyerRefPrNoPopList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}

//		Map<String,String> param = new HashMap<String, String>();
//		//Map<String,Object> 를 Map<String,String>으로 변환
//		for(Map.Entry<String, Object> entry : pMap.entrySet()){
//			param.put(entry.getKey(), entry.getValue() == null ? null : entry.getValue().toString());
//		}
		
		List<Map<String, String>> _data = commonRefPrNoPopupService.buyerRefPrNoPopList_v2(pMap); 
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
