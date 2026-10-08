package com.koreab2b.mro.master.mdam.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.application.annotation.NoLoginCheck;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.master.mdam.service.MasterMdAmMbrcmpyRegService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdAmMbrcmpyRegController")
public class MasterMdAmMbrcmpyRegController {

	private static final Logger logger = LoggerFactory.getLogger(MasterMdAmMbrcmpyRegController.class);

	@Autowired
	private MasterMdAmMbrcmpyRegService masterMdAmMbrcmpyRegService;
	
/*	20220726 ISMS 불필요 페이지 삭제 HSJ
	@RequestMapping(value = "/mdam/showMasterMdAmMbrcmpyReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmMbrcmpyReg(ModelMap pModel, HttpServletRequest req) {
		return "/master/mdam/masterMdAmMbrcmpyRegList";
	}
*/	
/*	20260703 ISMS 불필요 페이지 삭제 HSJ	
	@RequestMapping(value = "/mdam/showMasterMdAmMbrcmpyRegEnd.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmMbrcmpyRegEnd(ModelMap pModel, HttpServletRequest req) {
		return "/master/mdam/masterMdAmMbrcmpyRegEndList";
	}
*/
	
	// 회원가입 완료 (리뉴얼 v2)
	@RequestMapping(value = "/mdam/showMasterMdAmMbrcmpyRegEnd_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmMbrcmpyRegEnd_v2(ModelMap pModel, HttpServletRequest req) {
		return "/master/mdam/masterMdAmMbrcmpyRegEndList_v2";
	}

	// 조회
	@RequestMapping(value = "/mdam/getMasterMdAmMbrcmpyRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> searchMasterMdAmMbrcmpyRegList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("요청 파라미터 : {}", pMap);

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = masterMdAmMbrcmpyRegService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}

	// 엑셀다운로드
	@RequestMapping(value = "/mdam/excelMasterMdAmMbrcmpyRegList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public void excelList(HttpServletRequest req,HttpServletResponse res, @RequestParam Map<String, Object> pMap){
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		List<Map<String,String>> _data = masterMdAmMbrcmpyRegService.getList(pMap);
		IBSheetUtil.excelOut(req, res, _data);
	}
		
	// 저장
	@RequestMapping(value = "/mdam/saveMasterMdAmMbrcmpyRegList.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> updateMasterMdAmMbrcmpyReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdAmMbrcmpyRegService.updateSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		return _response;
		
	}

	// 삭제
	@RequestMapping(value = "/mdam/delMasterMdAmMbrcmpyRegList.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> delMasterMdAmMbrcmpyReg(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		String rtnMsg = masterMdAmMbrcmpyRegService.delSelectedData(formData, gridData);

		_response.put("Message", rtnMsg);
		
		return _response;
	}
	//2016년 회원가입 완료
	@RequestMapping(value = "/mdam/showMasterMdAmMbrcmpyRegEnd_2016.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmMbrcmpyRegEnd_2016(ModelMap pModel, HttpServletRequest req) {
		return "main/2016/sub04/sub04_join_end";
	}

	// 리뉴얼 회원가입 완료
	@RequestMapping(value = "/mdam/showRenewalBuyerUserRegEnd.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showRenewalBuyerUserRegEnd(ModelMap pModel, HttpServletRequest req) {
		return "main/renewal_buyer_user_reg_end";
	}

	
	@RequestMapping(value = "/mdam/showMasterMdAmMbrUserReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterMdAmMbrcmpyReg(ModelMap pModel, HttpServletRequest req) {
		return "/master/mdam/masterMdAmMbrcmpyRegList_v2";
	}


	// 담당자명 확인
	@RequestMapping(value = "/mdam/getMasterMdAmMbrcmpyStaffNameCheck.do", method = RequestMethod.POST)
	@NoLoginCheck
	@ResponseBody
	public Map<String, Object> getMasterMdAmMbrcmpyStaffNameCheck(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		Map<String, String> result = masterMdAmMbrcmpyRegService.getStaffNameCheck(pMap);
		_response.put("data", result);
		return _response;
	}

	@RequestMapping(value = "/mdam/showMasterPartnerReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterPartnerReg(ModelMap pModel, HttpServletRequest req) {
		return "/main/renewal_partner_reg";
	}

		@RequestMapping(value = "/mdam/showMasterPartnerUserReg.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@NoLoginCheck
	public String showMasterPartnerUserReg(ModelMap pModel, HttpServletRequest req) {
		return "/main/renewal_partner_user_reg";
	}
	
	
}
