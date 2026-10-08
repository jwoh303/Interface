package com.koreab2b.mro.common.mdam.controller;

import java.util.ArrayList;
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

import com.koreab2b.mro.common.coco.service.CommonPopupService;
import com.koreab2b.mro.common.mdam.service.BuyerMdAmPrivateInfoAlterPopService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.master.mdam.service.MasterMdAmLogManageService;
import com.koreab2b.mro.util.CommonUtil;

@Controller("buyerMdAmPrivateInfoAlterPopController")
public class BuyerMdAmPrivateInfoAlterPopController {

	private static final Logger logger = LoggerFactory.getLogger(BuyerMdAmPrivateInfoAlterPopController.class);

	@Autowired
	private BuyerMdAmPrivateInfoAlterPopService buyerMdAmPrivateInfoAlterPopService;

	// 메일수신 항목 마스터 (ICOMCOD1.TYPE='MAIL') 조회 — 레거시 commonPopup.getUserMailRecvChoicePop 재사용
	@Autowired
	private CommonPopupService commonPopupService;

	// 감사로그(KEPSITE_LOG) 기록
	@Autowired
	private MasterMdAmLogManageService masterMdAmLogManageService;
	
	/**
	 * 개인정보 수정  조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/mdam/showBuyerMdAmPrivateInfoAlterPop.do", method = {RequestMethod.GET,RequestMethod.POST})
	public String getBuyerMdAmPrivateInfoAlterPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("/mdam/getBuyerMdAmPrivateInfoAlterPop.do 요청 파라미터 for jsp : {}", pMap); 
		
		pMap.put("T_KEY","3972624753");
		List<Map<String, String>> _userData = buyerMdAmPrivateInfoAlterPopService.getList(pMap);
		List<Map<String, String>> _approvedData = buyerMdAmPrivateInfoAlterPopService.getApprovedList(pMap);
		List<Map<String, String>> _referData = buyerMdAmPrivateInfoAlterPopService.getReferList(pMap);
		
		pModel.addAttribute("userData", CommonUtil.getListNvl(_userData));
		pModel.addAttribute("approvedData", CommonUtil.getListNvl(_approvedData));
		pModel.addAttribute("referData", CommonUtil.getListNvl(_referData));
		
		return "common/popup/mdam/buyerMdAmPrivateInfoAlterPop";
	}
	
	// 비밀번호 Valid Check
	@RequestMapping(value = "/mdam/pwdValidCheckBuyerMdAmPrivateInfoAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> pwdValidCheckBuyerMdAmPrivateInfoAlterPop(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		
		logger.debug("pwdValidCheckBuyerMdAmPrivateInfoAlterPop Map 요청 파라미터 : formData", pMap); 
		Map<String, Object> _response = new HashMap<String, Object>();

		String _result = buyerMdAmPrivateInfoAlterPopService.getPwdValidCheck(pMap);
		
		/* 성공시코드 OK , 실패시 메세지 전송 */
		_response.put("msg", _result);
		return _response;
	}
	
	/**
	 * _v2 PopupUtil 레이어 팝업용 JSON 조회 엔드포인트
	 * 기존 JSP 반환 메서드(getBuyerMdAmPrivateInfoAlterPop)와 동일한 Service 호출하되 JSON으로 반환
	 */
	@RequestMapping(value = "/mdam/getBuyerMdAmPrivateInfoForPopup_v2.do", method = {RequestMethod.GET, RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerMdAmPrivateInfoForPopup_v2(HttpServletRequest req, @RequestParam Map<String, String> pMap) {
		pMap.put("T_KEY", "3972624753");

		/* 감사로그 — 운영사 회원사관리 팝업(CommonPopupInfoDaoImpl#commonList)과 동일 형식 */
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		String _attr01 = "";
		for (Map.Entry<String, String> entry : pMap.entrySet()) {
			_attr01 += entry.getKey() + "=" + entry.getValue() + "/";
		}
		Map<String, Object> _log = new HashMap<String, Object>();
		_log.putAll(pMap);
		_log.put("SYSTEM",   "KOREAB2B");
		_log.put("MENU",     "사용자상세조회(팝업)");
		_log.put("LOG_TYPE", "조회");
		_log.put("STMT_ID",  "common.mdam.selectBuyerMdAmPrivateInfoAlterPopList");
		_log.put("ATTR_01",  _attr01);
		_log.put("ATTR_02",  CommonUtil.nvl(pMap.get("st_user_id")));
		_log.put("ATTR_03",  "");
		_log.put("REG_ID",   _sessionInfo != null ? _sessionInfo.getUserId() : "");
		_log.put("REG_IP",   CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
		masterMdAmLogManageService.saveLog(_log);

		Map<String, Object> _response = new HashMap<String, Object>();
		// 기본 결재경로 멤버 통합 조회 (1 SQL) 후 GUBUN 별 분류
		List<Map<String, String>> _members = buyerMdAmPrivateInfoAlterPopService.getDefaultApprovalLineMembers(pMap);
		List<Map<String, String>> _approved = new ArrayList<Map<String, String>>();
		List<Map<String, String>> _refer    = new ArrayList<Map<String, String>>();
		List<Map<String, String>> _agree    = new ArrayList<Map<String, String>>();
		if (_members != null) {
			for (Map<String, String> r : _members) {
				String g = CommonUtil.nvl(r.get("GUBUN"), "");
				if ("C".equals(g))      _approved.add(r);
				else if ("R".equals(g)) _refer.add(r);
				else if ("H".equals(g)) _agree.add(r);
			}
		}
		_response.put("userData",     CommonUtil.getListNvl(buyerMdAmPrivateInfoAlterPopService.getList(pMap)));
		_response.put("approvedData", CommonUtil.getListNvl(_approved));
		_response.put("referData",    CommonUtil.getListNvl(_refer));
		_response.put("agreeData",    CommonUtil.getListNvl(_agree));
		// 메일수신 항목 마스터: 레거시 commonPopupService 재사용 (commonPopup.getUserMailRecvChoicePop)
		_response.put("mailChoiceMaster", CommonUtil.getListNvl(commonPopupService.getUserMailRecvChoicePop(pMap)));
		return _response;
	}

	// 저장
	@RequestMapping(value = "/mdam/updateBuyerMdAmPrivateInfoAlterPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateBuyerMdAmPrivateInfoAlterPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _response = new HashMap<String, Object>();
		String T_KEY  = "3972624753";
			//logger.debug("요청 파라미터 : _list", _list);
			logger.debug("/mdam/updateBuyerMdAmPrivateInfoAlterPop.do Map 요청 파라미터 : formData", pMap); 
			SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
			logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
			
			pMap.put("T_KEY", T_KEY);
			pMap.put("REG_IP", CommonUtil.nvl(CommonUtil.getRemoteAddr(req)));
			pMap.put("st_job_user_id", _sessionInfo.getUserId());
			String flag = buyerMdAmPrivateInfoAlterPopService.updateSelectedData(pMap);
			_response.put("msg", flag);

			return  _response;
		}
}
