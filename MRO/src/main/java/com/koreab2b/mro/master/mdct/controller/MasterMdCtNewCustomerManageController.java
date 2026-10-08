package com.koreab2b.mro.master.mdct.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

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

import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdct.service.MasterMdCtNewCustomerManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("masterMdCtNewCustomerManageController")
public class MasterMdCtNewCustomerManageController {
	private static final Logger LOGGER  = LoggerFactory.getLogger(MasterMdCtNewCustomerManageController.class);
	
	@Autowired
	private MasterMdCtNewCustomerManageService masterMdCtNewCustomerManageService;
	
	// 조회
	@RequestMapping(value = "/mdct/getMasterMdCtNewCustomerManageList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMasterMdCtNewCustomerManageList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("getMasterMdCtNewCustomerManageList 요청 파라미터 : {}", pMap);
		//페이징용 파라미터의 셋팅
		//pMap = IBSheetUtil.addParamForPaging3(pMap);
		pMap = IBSheetUtil.removeSlash(pMap);
		List<Map<String,String>> _data = masterMdCtNewCustomerManageService.getList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	// 잠재고객 등록
	@RequestMapping(value = "/mdct/saveMasterMdCtNewCustomer.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterWmReReturnEntryPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerManageService.saveMasterMdCtNewCustomer(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}	
	// 저장
	@RequestMapping(value = "/mdct/saveMasterMdCtNewCustomerManageList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCtNewCustomerManageList(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap);
		LOGGER.debug("updateMasterMdCtNewCustomerManageList 요청 파라미터 : gridData {}", gridData);
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		LOGGER.debug("updateMasterMdCtNewCustomerManageList 요청 파라미터 : formData {}", formData);

		String rtnMsg = masterMdCtNewCustomerManageService.updateSelectedData(formData, gridData);

		// 성공시 : 1 실패시 : 0
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		
		return _response;
	}
	// 잠재고객 상세 조회
	@RequestMapping(value = "/mdct/getMasterMdCtNewCustomerManageDetailList.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getMasterMdCtNewCustomerManageDetailList(HttpServletRequest req, ModelMap pModel, @RequestParam Map<String, String> pMap) {
		/*로그관련 셋팅*/
		SessionInfo _sessionInfo = (SessionInfo)req.getSession().getAttribute("sessionInfo");
		if (_sessionInfo != null) {
			pMap.put("REG_ID", _sessionInfo.getUserId());
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		}else{
			pMap.put("REG_ID","");
			pMap.put("REG_IP", "");
		}
		
		List<Map<String, String>> _data = masterMdCtNewCustomerManageService.getDetailList(pMap);

		pModel.addAttribute("data", CommonUtil.getListNvl(_data));
		return "common/popup/mdct/masterMdctNewCustomerPop";
	}
	// 잠재고객 수정
	@RequestMapping(value = "/mdct/updateMasterMdCtNewCustomer.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCtNewCustomer(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerManageService.updateMasterMdCtNewCustomer(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 종결처리
	@RequestMapping(value = "/mdct/endMasterMdCtNewCustomer.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> endMasterMdCtNewCustomer(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerManageService.endMasterMdCtNewCustomer(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 잠재고객 사전영업 완료
	@RequestMapping(value = "/mdct/saveMasterMdCtNewCustomerMtComp.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> saveMasterMdCtNewCustomerMtComp(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerManageService.saveMasterMdCtNewCustomerMtComp(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	// 기업정보업데이트
	@RequestMapping(value = "/mdct/updateMasterMdCtMSTNewCustomer.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMdCtMSTNewCustomer(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		String msg = masterMdCtNewCustomerManageService.updateMasterMdCtMSTNewCustomer(pMap);
	 
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
