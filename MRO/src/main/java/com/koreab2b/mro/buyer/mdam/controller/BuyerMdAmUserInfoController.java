package com.koreab2b.mro.buyer.mdam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.buyer.mdam.service.BuyerMdAmUserInfoService;
import com.koreab2b.mro.common.coco.service.CommonPopupService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.manager.login.service.LoginService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmUserInfoController")
public class BuyerMdAmUserInfoController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmUserInfoController.class);

	@Autowired
	private BuyerMdAmUserInfoService buyerMdAmUserInfoService;
	@Autowired
	private CommonPopupService commonPopupService;
	@Autowired
	private LoginService loginService;
	
	// 조회
	@RequestMapping(value = "/mdam/getBuyerMdAmUserInfoList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMdAmUserInfoList(HttpServletRequest req, ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		pMap.put("T_KEY","3972624753");
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		List<Map<String, String>> _userData = buyerMdAmUserInfoService.getList(pMap);
		List<Map<String, String>> _approvedData = buyerMdAmUserInfoService.getApprovedList(pMap);
		List<Map<String, String>> _referData = buyerMdAmUserInfoService.getReferList(pMap);
		List<Map<String, String>> _agreeData = buyerMdAmUserInfoService.getAgreeList(pMap);
		List<Map<String, String>> _userMailRecvChoiceData = commonPopupService.getUserMailRecvChoicePop(pMap);
		
		pModel.addAttribute("userData", CommonUtil.getListNvl(_userData));
		pModel.addAttribute("approvedData", CommonUtil.getListNvl(_approvedData));
		pModel.addAttribute("referData", CommonUtil.getListNvl(_referData));
		pModel.addAttribute("agreeData", CommonUtil.getListNvl(_agreeData));
		pModel.addAttribute("userMailRecvChoiceData", CommonUtil.getListNvl(_userMailRecvChoiceData));
		
		String uiVersion = (String) req.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			return "buyer/mdam/buyerMdAmUserInfoList_v2";
		}else{
			return "buyer/mdam/buyerMdAmUserInfoList";
		}
	}
	
	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdam/pwdValidCheckBuyerMdAmUserInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> pwdValidCheckBuyerMdAmUserInfo(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		logger.debug("pwdValidCheckBuyerMdAmUserInfo Map 요청 파라미터 : formData", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		String _result = buyerMdAmUserInfoService.getPwdValidCheck(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	
	// 저장
	@RequestMapping(value = "/mdam/updateBuyerMdAmUserInfoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmUserInfo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		String T_KEY  = "3972624753";

		logger.debug("/mdam/updateBuyerMdAmUserInfoList.do Map 요청 파라미터 : formData", pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("T_KEY", T_KEY);
		pMap.put("st_user_id", _sessionInfo.getUserId());
		String flag = buyerMdAmUserInfoService.updateSelectedData(pMap);
		_response.put("msg", flag);
		
		//session값 다시 넣어주기
		req.getSession().removeAttribute("sessionInfo");
		
		SessionInfo _sessionInfo2 = loginService.getSessionInfo(pMap.get("st_user_id"));
		HttpSession _session = req.getSession(false);
		_session.setAttribute("sessionInfo", _sessionInfo2);

		return  _response;
	}
}
