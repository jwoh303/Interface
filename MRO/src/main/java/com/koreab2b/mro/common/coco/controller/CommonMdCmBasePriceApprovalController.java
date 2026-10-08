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

import com.koreab2b.mro.common.coco.service.CommonMdCmBasePriceApprovalService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

/**
 * 표준DB 기준가 인하 결재 (DOC_TYPE = BP 단건 / BPM 일괄)
 *
 * ICOMCOD1 TYPE='APPR' 의 TEXT4 = '/common/approval/MdCmBasePriceCommon' 이 이 컨트롤러를 가리킨다.
 *   상신    : MdCmBasePriceCommonRequest.do
 *   결재/반려 : MdCmBasePriceCommonApproval.do   (PASS_KN 1 결재 / 3 반려)
 *   취소    : MdCmBasePriceCommonCancel.do
 */
@Controller("CommonMdCmBasePriceApprovalController")
public class CommonMdCmBasePriceApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMdCmBasePriceApprovalController.class);

	@Autowired
	private CommonMdCmBasePriceApprovalService commonMdCmBasePriceApprovalService;

	/**
	 * 결재 / 반려
	 */
	@RequestMapping(value ="/common/approval/MdCmBasePriceCommonApproval.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> commonApproval(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("MdCmBasePriceCommonApproval  요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID", _sessionInfo.getUserId());
		pMap.put("USER_DEPT", _sessionInfo.getDepartment());
		pMap.put("USER_NAME", _sessionInfo.getUserNameLoc());
		pMap.put("USER_TEL", _sessionInfo.getTel());

		commonMdCmBasePriceApprovalService.approval(pMap);

		_msg.put("MSG", "OK");
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 상신 요청
	 */
	@RequestMapping(value ="/common/approval/MdCmBasePriceCommonRequest.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> commonRequest(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("MdCmBasePriceCommonRequest  요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID", _sessionInfo.getUserId());
		pMap.put("USER_DEPT", _sessionInfo.getDepartment());
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc());

		String docu_no = commonMdCmBasePriceApprovalService.request(pMap);

		_msg.put("DOCU_NO", docu_no);
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 상신 취소
	 */
	@RequestMapping(value ="/common/approval/MdCmBasePriceCommonCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> commonCancel(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("MdCmBasePriceCommonCancel  요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID", _sessionInfo.getUserId());
		pMap.put("USER_DEPT", _sessionInfo.getDepartment());
		pMap.put("APPR_STATUS","D");

		String msg = commonMdCmBasePriceApprovalService.cancel(pMap);

		_msg.put("MSG", msg);
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 결재대상 조회 팝업 (s12 / s20). ICOMCOD1 APPR 의 TEXT2·TEXT3 가 가리키는 화면.
	 */
	@RequestMapping(value ="/common/popup/approval/approvalBpListPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String approvalBpListPop(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("approvalBpListPop  요청 파라미터 : {}", pMap);

		List<Map<String,String>> _dataList = commonMdCmBasePriceApprovalService.getApprList(pMap);

		// 속성명 'data' 는 기존 결재대상 팝업(approvalScaListPop 등)의 관례를 따른 것이다
		pModel.addAttribute("data", _dataList);
		return "common/popup/approval/approvalBpListPop";
	}
}
