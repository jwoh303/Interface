package com.koreab2b.mro.common.mdct.controller;

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

import com.koreab2b.mro.common.mdct.service.SellerMdCtPrivateInfoAlterPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdCtPrivateInfoAlterPopController")
public class SellerMdCtPrivateInfoAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdCtPrivateInfoAlterPopController.class);

	@Autowired
	private SellerMdCtPrivateInfoAlterPopService sellerMdCtPrivateInfoAlterPopService;
	
	/**
	 * 개인정보 수정  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdct/showSellerMdCtPrivateInfoAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getSellerMdCtPrivateInfoAlterPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdct/getSellerMdCtPrivateInfoAlterPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		pMap.put("st_com_code", _sessionInfo.getComCode());
		List<Map<String, String>> _data = sellerMdCtPrivateInfoAlterPopService.getList(pMap); 
		pModel.addAttribute("data", CommonUtil.getListNvl(_data)); 
		return "common/popup/mdct/sellerMdCtPrivateInfoAlterPop";
	}
	
	// 저장
	@RequestMapping(value = "/mdct/saveSellerMdCtPrivateInfoAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmPrivateInfoAlterPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		//logger.debug("요청 파라미터 : _list", _list);
		logger.debug("/mdct/saveSellerMdCtPrivateInfoAlterPop.do Map 요청 파라미터 : formData", pMap); 
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		
		pMap.put("st_com_code", _sessionInfo.getComCode());
		String flag = sellerMdCtPrivateInfoAlterPopService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
		}
}
