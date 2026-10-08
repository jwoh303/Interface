package com.koreab2b.mro.common.coco.controller;

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

import com.koreab2b.mro.common.coco.service.CommonCoCoApprovalAppointPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("commonCoCoApprovalAppointPopController")
public class CommonCoCoApprovalAppointPopController {
private static final Logger logger = LoggerFactory.getLogger(CommonCoCoApprovalAppointPopController.class);
	
	@Autowired
	private CommonCoCoApprovalAppointPopService commonCoCoApprovalAppointPopService;
	
	/**
	 * 결재자지정 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getCommonCoCoApprovalAppointPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getCommonCoCoApprovalAppointPop(ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("/mpiv/getCommonCoCoApprovalAppointPop.do 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code", CommonUtil.nvl(_sessionInfo.getComCode(),""));
		//pMap.put("st_user_id", CommonUtil.nvl(_sessionInfo.getUserId(),""));
		pMap.put("st_user_name", CommonUtil.nvl(_sessionInfo.getUserNameLoc(),""));
		pMap.put("st_user_dept", CommonUtil.nvl(_sessionInfo.getDepartment(),""));
		pMap.put("st_user_dept_name", CommonUtil.nvl(_sessionInfo.getDepartmentName(),""));
		pMap.put("st_user_tel", CommonUtil.nvl(_sessionInfo.getTel(),""));
		pMap.put("st_com_addr", CommonUtil.nvl(_sessionInfo.getAddressLoc(),""));
		
		List<Map<String, String>> _data = commonCoCoApprovalAppointPopService.getApprovalMultiPathList(pMap); 
		
		_response.put("data", CommonUtil.getListNvl(_data));
		return  _response;
	}
	
	/**
	 * 결재선 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/setCommonCoCoApprovalInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> setCommonCoCoApprovalInfo(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("setCommonCoCoApprovalInfo 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//pMap.put("st_user_id", CommonUtil.nvl(_sessionInfo.getUserId(),""));
		
		String msg = commonCoCoApprovalAppointPopService.setCommonCoCoApprovalInfo(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 결재선 삭제
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/delCommonCoCoApprovalInfo.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delCommonCoCoApprovalInfo(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("delCommonCoCoApprovalInfo 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		//SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//pMap.put("st_user_id", CommonUtil.nvl(_sessionInfo.getUserId(),""));
		pMap.put("app_path", CommonUtil.nvl((String)pMap.get("app_path"),""));
		
		String msg = commonCoCoApprovalAppointPopService.delCommonCoCoApprovalInfo(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 등록 된 결재/참조자 목록 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getApproverInfoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getApproverInfoList(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("getApproverInfoList 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// 결재자 목록 조회
		pMap.put("arry_user_id", CommonUtil.nvl((String)pMap.get("to_list"),""));
		pMap.put("gubun", "결재");
		
		List<Map<String, String>> to_data = commonCoCoApprovalAppointPopService.getApprovalMultiPathUserNm_arry(pMap);
		
		// 참조자 목록 조회
		pMap.put("arry_user_id", CommonUtil.nvl((String)pMap.get("cc_list"),""));
		pMap.put("gubun", "참조");
		List<Map<String, String>> cc_data = commonCoCoApprovalAppointPopService.getApprovalMultiPathUserNm_arry(pMap); 
		
		_response.put("to_data", CommonUtil.getListNvl(to_data));
		_response.put("cc_data", CommonUtil.getListNvl(cc_data));
		return  _response;
	}
	
	/**
	 * 결재/참조자 목록 검색 조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/getApprovalMultiPathUserList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getApprovalMultiPathUserList(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("getApprovalMultiPathUserList 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("st_com_code", CommonUtil.nvl(_sessionInfo.getComCode(),""));
		
		pMap.put("key", CommonUtil.nvl((String)pMap.get("key"),""));
		pMap.put("qstr", CommonUtil.nvl((String)pMap.get("qstr"),""));
		
		List<Map<String, String>> _data = commonCoCoApprovalAppointPopService.getApprovalMultiPathUserList(pMap);
		
		_response.put("data", CommonUtil.getListNvl(_data));
		return  _response;
	}
	
	/**
	 * 결재/참조자 목록 정보 저장
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/coco/regApproverInfoList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> regApproverInfoList(@RequestParam Map<String, String> pMap, HttpServletRequest request) {
		logger.debug("regApproverInfoList 요청 파라미터 for jsp : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//pMap.put("st_user_id", CommonUtil.nvl(_sessionInfo.getUserId(),""));
		pMap.put("app_path", CommonUtil.nvl((String)pMap.get("app_path"),""));
		pMap.put("to_str_id", CommonUtil.nvl((String)pMap.get("to_str_id"),""));
		pMap.put("cc_str_id", CommonUtil.nvl((String)pMap.get("cc_str_id"),""));
		
		String msg = commonCoCoApprovalAppointPopService.regApproverInfoList(pMap);
		
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
