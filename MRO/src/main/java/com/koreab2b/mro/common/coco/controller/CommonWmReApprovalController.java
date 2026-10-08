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

import com.koreab2b.mro.common.coco.service.CommonWmReApprovalService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;

@Controller("CommonWmReAApprovalController")
public class CommonWmReApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(CommonWmReApprovalController.class);

	@Autowired
	private CommonWmReApprovalService commonWmReApprovalService;
	   
	
	/**
	 * 결재 처리 부분
	 * 
	 * 	 * NG	견적의뢰
		NS	소상합의
		PA	단가승인
		PR	구매요청
		PX	구매발주
		RC	견적초기화
		
	 *  PASS_KN 에 따라... 1 결재 3반려
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/WmReCommonApproval.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonApproval( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("WmReCommonApproval  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NAME", _sessionInfo.getUserNameLoc()); //사용자이름
		pMap.put("USER_TEL", _sessionInfo.getTel()); // 사용자전화번호
		String msg = commonWmReApprovalService.approval(pMap);		  
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	  
	
	
	/**
	 * 상신 요청
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */ 
	@RequestMapping(value ="/common/approval/WmReCommonRequest.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonRequest( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("WmReCommonRequest  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명	
		String docu_no = "";
		
		docu_no = commonWmReApprovalService.request(pMap); //상신구현 필요	  
	   
		_msg.put("DOCU_NO", docu_no); 
		_response.put("msg", _msg);
			
		return  _response;
	}
	  
	/**
	 * 상신 취소
	 * 
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/WmReCommonCancel.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonCancel( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("WmReCommonCancel  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonCancel " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("APPR_STATUS","D"); // 결재상태
		
		String msg = commonWmReApprovalService.cancel(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 반품 조회화면
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalWmReListPop.do", method = RequestMethod.GET)
	public String approvalWmReListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("approvalPrListPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String,String>> _data = commonWmReApprovalService.approvalWmReListPop(pMap);		 
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	/**
	 * 오류재실행
	 */
	@RequestMapping(value = "/common/popup/approval/runlWmReListPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> runlWmReListPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		String msg = commonWmReApprovalService.runlWmReListPop(pMap);
		msg   = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
}
