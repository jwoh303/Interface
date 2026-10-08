package com.koreab2b.mro.seller.mdam.controller;

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

import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.seller.mdam.service.SellerMdAmUserInfoService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("sellerMdAmUserInfoController")
public class SellerMdAmUserInfoController {

	private static final Logger logger = LoggerFactory.getLogger(SellerMdAmUserInfoController.class);

	@Autowired
	private SellerMdAmUserInfoService sellerMdAmUserInfoService;
	
	// 조회
	@RequestMapping(value = "/mdam/getSellerMdAmUserInfoList.do", method = RequestMethod.POST)
	public String getSellerMdAmUserInfoList(HttpServletRequest req,ModelMap pModel ,@RequestParam Map<String, String> pMap) {		
		
		logger.debug("/mdam/getSellerMdAmUserInfoList.do 요청 파라미터 : {}", pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("T_KEY","3972624753");
		List<Map<String, String>> _data = sellerMdAmUserInfoService.getList(pMap);
		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		pModel.addAllAttributes(pMap);
		
		return "seller/mdam/sellerMdAmUserInfoList";
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveSellerMdAmUserInfoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdAmUserInfo(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		String flag = sellerMdAmUserInfoService.updateSelectedData(pMap);
		_response.put("msg", flag);

		return  _response;
	}
	// 비밀번호변경
	@RequestMapping(value = "/mdam/saveSellerMdAmUsePwd.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdAmUsePwd(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		String flag = sellerMdAmUserInfoService.updateSellerMdAmUsePwd(pMap);
		_response.put("msg", flag);

		return  _response;
	}

	// 비밀번호변경 v2 (현재 비밀번호와 동일 방지 검증 추가)
	@RequestMapping(value = "/mdam/saveSellerMdAmUsePwd_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateSellerMdAmUsePwd_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		pMap.put("st_com_code", _sessionInfo.getComCode());
		String flag = sellerMdAmUserInfoService.updateSellerMdAmUsePwd_v2(pMap);
		_response.put("msg", flag);

		return  _response;
	}

	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdam/pwdValidCheckSellerMdAmUserInfoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> pwdValidCheckSellerMdAmUserInfoList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		logger.debug("pwdValidCheckSellerMdAmUserInfoList Map 요청 파라미터 : formData", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		pMap.put("st_user_id", _sessionInfo.getUserId());
		String _result = sellerMdAmUserInfoService.getPwdValidCheck(pMap);

		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}

	/**
	 * 개인정보 조회 (JSON 응답) - 리뉴얼 팝업 전용
	 *
	 * @param req HttpServletRequest
	 * @return Map<String, Object> JSON 응답
	 */
	@RequestMapping(value = "/mdam/getSellerMdAmUserInfoJson.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getSellerMdAmUserInfoJson(HttpServletRequest req) {

		logger.debug("/mdam/getSellerMdAmUserInfoJson.do 호출");
		Map<String, Object> _response = new HashMap<String, Object>();

		try {
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");

			Map<String, String> _params = new HashMap<String, String>();
			_params.put("st_user_id", _sessionInfo.getUserId());
			_params.put("st_com_code", _sessionInfo.getComCode());
			_params.put("T_KEY", "3972624753");

			List<Map<String, String>> _dataList = sellerMdAmUserInfoService.getList(_params);

			if (_dataList != null && _dataList.size() > 0) {
				_response.put("msg", "OK");
				_response.put("data", _dataList.get(0));
				logger.debug("사용자 정보 조회 성공: {}", _sessionInfo.getUserId());
			} else {
				_response.put("msg", "ERR");
				_response.put("message", "사용자 정보를 찾을 수 없습니다.");
				logger.warn("사용자 정보 없음: {}", _sessionInfo.getUserId());
			}

		} catch (Exception e) {
			logger.error("개인정보 조회 오류", e);
			_response.put("msg", "ERR");
			_response.put("message", "조회 중 오류가 발생했습니다: " + e.getMessage());
		}

		return _response;
	}
}
