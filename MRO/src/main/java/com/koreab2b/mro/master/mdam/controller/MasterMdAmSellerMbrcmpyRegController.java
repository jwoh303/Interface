package com.koreab2b.mro.master.mdam.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.master.mdam.service.MasterMdAmSellerMbrcmpyRegService;

@Controller("masterMdAmSellerMbrcmpyRegController")
public class MasterMdAmSellerMbrcmpyRegController {

	@Autowired
	private MasterMdAmSellerMbrcmpyRegService masterMdAmSellerMbrcmpyRegService;
	
	
	// 아이디 중복체크
	@RequestMapping(value = "/mdam/getMasterMdAmSellerMbrcmpyRegIDCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmSellerMbrcmpyRegIDCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdAmSellerMbrcmpyRegService.getIDCheck(pMap);
			
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}

	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdam/getMasterMdAmSellerMbrcmpyRegPwdValidCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmSellerMbrcmpyRegPwdValidCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdAmSellerMbrcmpyRegService.getPwdValidCheck(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
		
	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmSellerMbrcmpyRegList.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> updateMasterMdAmSellerMbrcmpyReg(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		 _response = masterMdAmSellerMbrcmpyRegService.updateSelectedData(pMap);

		return _response;

	}

	// 가입여부 확인 (사업자등록번호)
	@RequestMapping(value = "/mdam/getMasterMdAmMbrcmpyIrsCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmMbrcmpyIrsCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> result = masterMdAmSellerMbrcmpyRegService.getIrsCheck(pMap);
		_response.put("data", result);
		return _response;
	}
}
