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

import com.koreab2b.mro.common.coco.service.CommonCaImApprovalService;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonCaImApprovalController")
public class CommonCaImApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(CommonCaImApprovalController.class);

	@Autowired
	private CommonCaImApprovalService commonCaImApprovalService;
	
	/**
	 * 상신 요청
	 * 
	 * IM	카탈로그 정보 일괄변경
	 * @param pMap
	 * @return
	 * @throws Exception
	 */ 
	@RequestMapping(value ="/common/approval/CaImCommonRequest.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> caImCommon( ModelMap pModel, @RequestParam Map<String, String> pMap, HttpServletRequest request) { 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		String docu_no = "";
		
		docu_no = commonCaImApprovalService.request(pMap); //상신구현 필요
		_msg.put("DOCU_NO", docu_no); 
		_response.put("msg", _msg);
			
		return  _response;
	}
	/**
	 * 카탈로그정보수정 결재내역상세 IM
	 * 
	 * ICOMCOD1 -> TYPE = 'IM'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalImListPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String approvalImListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalImListPop 요청 파라미터 for jsp : {}", pMap); 
		// 페이징처리 유무
		String pagingYn = CommonUtil.nvl(pMap.get("DOC_TYPE"),"");
		if(!pagingYn.equals("")){ // 결재내역상세일때는 페이징 처리 x
			// 페이징처리 시작
			pMap.put("onepagerow", "30");	 // row 수
			pMap = CommonUtil.PagingPrc(pMap);
			pMap.put("paging", "1");
			// 페이징처리 종료
		}
		List<Map<String,String>> _data = commonCaImApprovalService.approvalImListPop(pMap);
		pModel.addAttribute("data", _data);		
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	
	/**
	 * 결재 처리 부분
	 * 
	 * 	 * IM	카탈로그 정보 일괄변경
		
	 *  PASS_KN 에 따라... 1 결재 3반려
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CaImCommonApproval.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonApproval( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("CaImCommonApproval  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NAME", _sessionInfo.getUserNameLoc()); //사용자이름
		pMap.put("USER_TEL", _sessionInfo.getTel()); // 사용자전화번호
		
		String msg = commonCaImApprovalService.approval(pMap);		  
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	  
	  
	/**
	 * 상신 취소
	 * 
	 * 	 * IM	카탈로그 정보 일괄변경
		
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CaImCommonCancel.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonCancel( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("NgNsRcPaCommonCancel  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		
		String msg = commonCaImApprovalService.cancel(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
}
