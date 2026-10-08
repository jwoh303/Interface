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
import com.koreab2b.mro.master.mdam.service.MasterMdAmBuyerMbrcmpyRegService;

@Controller("masterMdAmBuyerMbrcmpyRegController")
public class MasterMdAmBuyerMbrcmpyRegController {

	@Autowired
	private MasterMdAmBuyerMbrcmpyRegService masterMdAmBuyerMbrcmpyRegService;
	
	// 조회
	/* 구 디자인(회원가입) 삭제처리. 2020-04-22 현명환
	@RequestMapping(value = "/mdam/showMasterMdAmBuyerMbrcmpyReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmBuyerMbrcmpyRegList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		return "/master/mdam/masterMdAmBuyerMbrcmpyRegList";
	}
	*/
	// 아이디 중복체크
	@RequestMapping(value = "/mdam/getMasterMdAmBuyerMbrcmpyRegIDCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmBuyerMbrcmpyRegIDCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdAmBuyerMbrcmpyRegService.getIDCheck(pMap);
			
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	
	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdam/getMasterMdAmBuyerMbrcmpyRegPwdValidCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmBuyerMbrcmpyRegPwdValidCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdAmBuyerMbrcmpyRegService.getPwdValidCheck(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
		
	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmBuyerMbrcmpyRegList.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> updateMasterMdAmBuyerMbrcmpyReg(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		_response = masterMdAmBuyerMbrcmpyRegService.updateSelectedData(pMap);
		
		return _response;
	}
}
