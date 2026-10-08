package com.koreab2b.mro.buyer.mdam.controller;

import java.util.HashMap;
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

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmCmpyCorpManageService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmCmpyCorpManageController")
public class BuyerMdAmCmpyCorpManageController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmCmpyCorpManageController.class);

	@Autowired
	private BuyerMdAmCmpyCorpManageService buyerMdAmCmpyCorpManageService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmCmpyCorpManageList.do", method = RequestMethod.POST)
	public String getBuyerMdAmCmpyCorpManageList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		logger.debug("/mdam/buyerMdAmCmpyCorpManageService.do 요청 파라미터 for jsp : {}", pMap);
		/*세션 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("SESSION_BUYER_CODE", _sessionInfo.getComCode());
		}
		List<Map<String, String>> _data = buyerMdAmCmpyCorpManageService.getList(pMap);
		List<Map<String, String>> _passData = buyerMdAmCmpyCorpManageService.getPassList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAttribute("data_pass", CommonUtil.getListNvl(_passData));

		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "buyer/mdam/buyerMdAmCmpyCorpManageList_v2";
		}
		return "buyer/mdam/buyerMdAmCmpyCorpManageList";
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveBuyerMdAmCmpyCorpManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmCmpyCorpManage(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		
		//logger.debug("요청 파라미터 : _list", _list);
		//logger.debug("/mdam/saveBuyerMdAmCmpyCorpManageList.do MultiValueMap 요청 파라미터 : formData", _pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		String flag = buyerMdAmCmpyCorpManageService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
}
