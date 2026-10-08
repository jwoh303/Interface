package com.koreab2b.mro.master.mdam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdam.service.MasterMdAmUserRegService;
import com.koreab2b.mro.util.CommonCodeDao;
import com.koreab2b.mro.util.StaticContextAccessor;

@Controller("masterMdAmUserRegController")
public class MasterMdAmUserRegController {

	@Autowired
	private MasterMdAmUserRegService masterMdAmUserRegService;
/*	20220726 ISMS 불필요 페이지 삭제 HSJ
	@RequestMapping(value = "/mdam/showMasterMdAmUserReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmUserRegList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		return "/master/mdam/masterMdAmUserRegList";
	}
*/	
	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmUserRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> searchMasterMdAmUserRegList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmUserRegService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// 아이디 중복체크
	@RequestMapping(value = "/mdam/getMasterMdAmUserRegIDCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmUserRegIDCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdAmUserRegService.getIDCheck(pMap);
			
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	
	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdam/getMasterMdAmUserRegPwdValidCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmUserRegPwdValidCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = masterMdAmUserRegService.getPwdValidCheck(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}

	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmUserRegList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> updateMasterMdAmUserReg(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = masterMdAmUserRegService.updateSelectedData(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
		
	}
	
	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmUserSslRegList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@NoLoginCheck
	@ResponseBody
	public String updateMasterMdAmUserSslReg(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		pMap.put("T_KEY","3972624753");

		String _rtnMsg = masterMdAmUserRegService.updateSelectedData(pMap);

		return "/mdam/showMasterMdAmUserReg.do";
		
	}
	// hash패스워드 저장 변경
	@RequestMapping(value = "/mdam/saveMasterMdAmPasswordHashRegList.do", method = {RequestMethod.GET, RequestMethod.POST})
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> saveMasterMdAmPasswordHashRegList(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();

		String _rtnMsg = masterMdAmUserRegService.updateSelectedHashData(pMap);

		_response.put("msg", _rtnMsg);
		return _response;
		
	}
	
	@RequestMapping(value = "/mdam/getSpecialCheckReturn.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getSpecialCheckReturn(HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();

		List<Map<String,String>> _data = StaticContextAccessor.getBean(CommonCodeDao.class).getSpecialCheckReturn(pMap); 
		
			
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("data", _data);
		return _response;
	}
	
	
}
