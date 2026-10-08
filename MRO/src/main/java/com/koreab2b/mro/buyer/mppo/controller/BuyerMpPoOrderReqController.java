package com.koreab2b.mro.buyer.mppo.controller;

import java.io.OutputStream;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;
import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mppo.service.BuyerMpPoOrderReqService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMpPoOrderReqController")
public class BuyerMpPoOrderReqController {
 
	@Autowired
	private BuyerMpPoOrderReqService buyerMpPoOrderReqService;
	
	@RequestMapping(value = "/mppo/getBuyerMpPoOrderReqList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMpPoOrderReqList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		// 화면 조회
		List<Map<String, String>> _data = buyerMpPoOrderReqService.getBuyerMpPoOrderReqList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
}
