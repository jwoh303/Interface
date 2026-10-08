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

import com.koreab2b.mro.common.coco.service.CommonMdCmBuyPriceApprovalService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

/**
 * 표준DB 구매정보 매입단가 인상 결재 (DOC_TYPE = SP 단건 / SPM 일괄)
 *
 * ICOMCOD1 TYPE='APPR' 의 TEXT4 = '/common/approval/MdCmBuyPriceCommon' 이 이 컨트롤러를 가리킨다.
 *   상신    : MdCmBuyPriceCommonRequest.do
 *   결재/반려 : MdCmBuyPriceCommonApproval.do
 *   취소    : MdCmBuyPriceCommonCancel.do
 */
@Controller("CommonMdCmBuyPriceApprovalController")
public class CommonMdCmBuyPriceApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(CommonMdCmBuyPriceApprovalController.class);

	@Autowired
	private CommonMdCmBuyPriceApprovalService commonMdCmBuyPriceApprovalService;

	/**
	 * 결재 / 반려
	 */
	@RequestMapping(value ="/common/approval/MdCmBuyPriceCommonApproval.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> commonApproval(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("MdCmBuyPriceCommonApproval  요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID", _sessionInfo.getUserId());
		pMap.put("USER_DEPT", _sessionInfo.getDepartment());
		pMap.put("USER_NAME", _sessionInfo.getUserNameLoc());
		pMap.put("USER_TEL", _sessionInfo.getTel());

		commonMdCmBuyPriceApprovalService.approval(pMap);

		_msg.put("MSG", "OK");
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 상신 요청
	 */
	@RequestMapping(value ="/common/approval/MdCmBuyPriceCommonRequest.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> commonRequest(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("MdCmBuyPriceCommonRequest  요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID", _sessionInfo.getUserId());
		pMap.put("USER_DEPT", _sessionInfo.getDepartment());
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc());

		String docu_no = commonMdCmBuyPriceApprovalService.request(pMap);

		_msg.put("DOCU_NO", docu_no);
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 상신 취소
	 */
	@RequestMapping(value ="/common/approval/MdCmBuyPriceCommonCancel.do", method = RequestMethod.POST)
	@ResponseBody
	public  Map<String, Object> commonCancel(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("MdCmBuyPriceCommonCancel  요청 파라미터 : {}", pMap);
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();

		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		pMap.put("USER_ID", _sessionInfo.getUserId());
		pMap.put("USER_DEPT", _sessionInfo.getDepartment());
		pMap.put("APPR_STATUS","D");

		String msg = commonMdCmBuyPriceApprovalService.cancel(pMap);

		_msg.put("MSG", msg);
		_response.put("msg", _msg);
		return  _response;
	}

	/**
	 * 결재대상 조회 팝업. ICOMCOD1 APPR 의 TEXT2·TEXT3 가 가리키는 화면.
	 */
	@RequestMapping(value ="/common/popup/approval/approvalSpListPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String approvalSpListPop(
			ModelMap pModel,
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) {

		logger.debug("approvalSpListPop  요청 파라미터 : {}", pMap);

		List<Map<String,String>> _dataList = commonMdCmBuyPriceApprovalService.getApprList(pMap);

		pModel.addAttribute("data", _dataList);
		return "common/popup/approval/approvalSpListPop";
	}
}
