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

import com.koreab2b.mro.common.coco.service.CommonApprovalService;
import com.koreab2b.mro.common.coco.service.CommonNgNsRcPaApprovalService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonNgNsRcPaApprovalController")
public class CommonNgNsRcPaApprovalController {

	private static final Logger logger = LoggerFactory.getLogger(CommonNgNsRcPaApprovalController.class);

	@Autowired
	private CommonNgNsRcPaApprovalService commonNgNsRcPaApprovalService;
	@Autowired
	private CommonApprovalService commonApprovalService;
	   
	
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
	@RequestMapping(value ="/common/approval/NgNsRcPaCommonApproval.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonApproval( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("NgNsRcPaCommonApproval  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonApproval " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NAME", _sessionInfo.getUserNameLoc()); //사용자이름
		pMap.put("USER_TEL", _sessionInfo.getTel()); // 사용자전화번호
		
		String msg = "";
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if("renewal".equals(uiVersion)){
			msg = commonNgNsRcPaApprovalService.approval_v2(pMap);
		}else{
			msg = commonNgNsRcPaApprovalService.approval(pMap);		  
		}
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	
	@RequestMapping(value = "/common/popup/approval/rejectNgNsListPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectNgNsListPop_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = commonApprovalService.rejectNgNsListPop_v2(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	  
	
	
	/**
	 * 상신 요청
	 * 
	 * NG	견적의뢰
		NS	소상합의
		PA	단가승인
		PR	구매요청
		PX	구매발주
		RC	견적초기화

	 * @param pMap
	 * @return
	 * @throws Exception
	 */ 
	@RequestMapping(value ="/common/approval/NgNsRcPaCommonRequest.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonRequest( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		logger.debug("NgNsRcPaCommonRequest  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		logger.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonRequest " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		
		String requesTemptYn = pMap.get("requesTemptYn").toString();
		String docu_no = "";
		
		// 신규견적 제출 시 RECV_FLAG = 'NG' 로 변경(결재 상신 클릭 전까지는 임시저장상태 : TS)
		if(pMap.get("DOC_TYPE").equals("NG")){
			String msg = commonNgNsRcPaApprovalService.setRqdtRecvFlagToNg(pMap);
		}
		
		if ("Y".equals(requesTemptYn)){
			docu_no = commonNgNsRcPaApprovalService.request_temp(pMap); //상신구현 필요		
		}else{
			docu_no = commonNgNsRcPaApprovalService.request(pMap); //상신구현 필요		
		}		  
	   
		_msg.put("DOCU_NO", docu_no); 
		_response.put("msg", _msg);
			
		return  _response;
	}
	  
	/**
	 * 상신 취소
	 * 
	 * 	 * NG	견적의뢰
		NS	소상합의
		PA	단가승인
		PR	구매요청
		PX	구매발주
		RC	견적초기화
		
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/NgNsRcPaCommonCancel.do", method = RequestMethod.POST) 
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
		
		String msg = commonNgNsRcPaApprovalService.cancel(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		logger.debug("_response " + _response);
			
		return  _response;
	}
	 
	
	/**
	 * 견적의뢰 NG
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalNgListPop.do", method = RequestMethod.GET)
	public String approvalNgListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalNgListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalNgListPop(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	@RequestMapping(value = "/common/popup/approval/approvalNgListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> approvalPrListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("approvalNgListPop_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		pMap.put("DOCU_NO", pMap.get("KEY_1"));
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalNgListPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	 
	/**
	 * 소상합의 NS
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalNsListPop.do", method = RequestMethod.GET)
	public String approvalNsListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalNsListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalNsListPop(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	@RequestMapping(value = "/common/popup/approval/approvalNsListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> approvalNsListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		logger.debug("approvalNgListPop_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		pMap.put("DOCU_NO", pMap.get("KEY_1"));
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalNsListPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	/**
	 * 단가승인 PA
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalPaListPop.do", method = RequestMethod.GET)
	public String approvalPaListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalPaListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalPaListPop(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	
	
	/**
	 * 견적초기화 RC
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalRcListPop.do", method = RequestMethod.GET)
	public String approvalRcListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalRcListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalRcListPop(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	/**
	 * 신규소싱 SO
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalSoListPop.do", method = RequestMethod.GET)
	public String approvalSoListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalRcListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalSoListPop(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	
	/**
	 * 신규카탈로그 등록 NCA
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalNcaListPop.do", method = RequestMethod.GET)
	public String approvalNcaListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalNcaListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalNcaListPop(pMap);
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	/**
	 * 표준카탈로그 등록 SCA
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalScaListPop.do", method = RequestMethod.GET)
	public String approvalScaListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalNcaListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalScaListPop(pMap);
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	/**
	 * 기존카탈로그 변경 CA
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalCaListPop.do", method = RequestMethod.GET)
	public String approvalCaListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalCaListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalCaListPop(pMap);
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}

	/**
	 * 신규소싱 SR
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalSrListPop.do", method = RequestMethod.GET)
	public String approvalSrListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalRcListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalSrListPop(pMap);		 
		pModel.addAttribute("data", _data);		
		
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	/**
	 * 데이터 다운로드
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalSrListDataPop.do", method = RequestMethod.GET)
	public String approvalSrListDataPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalRcListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalSrListPop(pMap);		 
		pModel.addAttribute("data", _data);		
		
		return  pMap.get("page"); // 업무별 상세 jsp 이동
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
	@RequestMapping(value = "/common/popup/approval/approvalRctListPop.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String approvalRctListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
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
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalRctListPop(pMap);
		pModel.addAttribute("data", _data);		
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	
	/**
	 * 카탈로그등록요청 CRS, CRU
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalCaRqListPop.do", method = RequestMethod.GET)
	public String approvalCaRqListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalCaRqListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalCaRqListPop(pMap);
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	
	/**
	 * 카탈로그 상태변경 CAST
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalCaStListPop.do", method = RequestMethod.GET)
	public String approvalCaStListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		logger.debug("approvalCaListPop 요청 파라미터 for jsp : {}", pMap); 
		
		List<Map<String,String>> _data = commonNgNsRcPaApprovalService.approvalCaStListPop(pMap);
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
}
