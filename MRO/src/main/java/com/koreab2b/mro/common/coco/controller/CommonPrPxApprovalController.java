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
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreab2b.mro.common.coco.service.CommonApprovalService;
import com.koreab2b.mro.common.coco.service.CommonPrPxApprovalService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonPrPxApprovalController")
public class CommonPrPxApprovalController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPrPxApprovalController.class);

	@Autowired
	private CommonPrPxApprovalService commonPrPxApprovalService;
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
	@RequestMapping(value ="/common/approval/PrPxCommonApproval.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonApproval( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		//LOGGER.debug("PrPxCommonApproval  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonApproval " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		
		String msg = commonPrPxApprovalService.approval(pMap);		  
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		//LOGGER.debug("_response " + _response);
			
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
	@RequestMapping(value ="/common/approval/PrPxCommonRequest.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonRequest( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
		//LOGGER.debug("PrPxCommonRequest  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		//LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonRequest " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		
		String requesTemptYn = pMap.get("requesTemptYn").toString();
		String docu_no = "";
		
		if ("Y".equals(requesTemptYn)){
			docu_no = commonPrPxApprovalService.request_temp(pMap); //상신구현 필요		
		}else{
			docu_no = commonPrPxApprovalService.request(pMap); //상신구현 필요		
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
	@RequestMapping(value ="/common/approval/PrPxCommonCancel.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonCancel( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
	//	LOGGER.debug("PrPxCommonCancel  요청 파라미터 : {}", pMap); 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
	//	LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonCancel " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonPrPxApprovalService.cancel(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	 
	 

	
	/**
	 * PR 주문 결과 조회 구매요청
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalPrListPop.do", method = RequestMethod.GET)
	public String approvalPrListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("approvalPrListPop 요청 파라미터 for jsp : {}", pMap);
		  
		/**
		 * 업무별상세구현
		 * /kr/customer/proxybuy/buyer_pr_display_pop.jsp?st_buyer=KRKEPB0004&st_po_no=PX13000088
		 * 구매요청(발주) 상세조회 참조
		 */
		
		List<Map<String,String>> _data = commonApprovalService.approvalPrListPop(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	@RequestMapping(value = "/common/popup/approval/approvalPrListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> approvalPrListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("approvalPrListPop_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		pMap.put("DOCU_NO", pMap.get("KEY_1"));
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = commonApprovalService.approvalPrListPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	/**
	 * PX 주문 결과 조회 구매발주
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalPxListPop.do", method = RequestMethod.GET)
	public String approvalPxListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("approvalPrListPop 요청 파라미터 for jsp : {}", pMap);
		  
		/**
		 * 업무별상세구현
		 * /kr/customer/proxybuy/buyer_px_display_pop.jsp?st_buyer=KRKEPB0004&st_po_no=PX14000018
		 * 구매요청(발주) 상세조회 참조
		 */
		
		List<Map<String,String>> _data = commonApprovalService.approvalPxListPop2(pMap);		  // 주문 결과
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}
	@RequestMapping(value = "/common/popup/approval/approvalPxListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> approvalPxListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("approvalPrListPop_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		pMap.put("DOCU_NO", pMap.get("KEY_1"));
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		List<Map<String,String>> _data = commonApprovalService.approvalPxListPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	/**
	 * OE 주문정보수정
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalOeListPop.do", method = RequestMethod.GET)
	public String approvalOeListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("approvalPrListPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String,String>> _data = commonApprovalService.approvalOeListPop(pMap);		 
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	
	
	/**
	 * OF 고객사 주문생성
	 * 
	 * ICOMCOD1 -> TYPE = 'APPR'
	 * 
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalOfListPop.do", method = RequestMethod.GET)
	public String approvalOfListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		//LOGGER.debug("approvalPrListPop 요청 파라미터 for jsp : {}", pMap); 
		List<Map<String,String>> _data = commonApprovalService.approvalOfListPop(pMap);		 
		pModel.addAttribute("data", _data);		
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	
	/**
	 * 부분반려
	 */
	@RequestMapping(value = "/common/popup/approval/rejectPrListPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectPrListPop(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = commonApprovalService.rejectPrListPop(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	@RequestMapping(value = "/common/popup/approval/rejectPrListPop_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> rejectPrListPop_v2(ModelMap pModel,  HttpServletRequest req, @RequestParam Map<String, String> pMap) {

		Map<String, Object> _msg = new HashMap<String, Object>();		
		Map<String, Object> _response = new HashMap<String, Object>();
		
		String msg = commonApprovalService.rejectPrListPop_v2(pMap);
		
		msg = "UPDATE_OK";
		_msg.put("MSG", msg); 
		_response.put("msg", _msg);
		return  _response;
	}
	
	/**
	 * 고객사 주문 부분 일괄반려
	 */
	@RequestMapping(value = "/common/popup/approval/rejectPrListMultiPop.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updateMasterMpRqReqQuotReceipt(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		String rtnMsg = commonApprovalService.updateSelectedData(formData, gridData);

		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		_response.put("Result",mp);
		_response.put("Message", rtnMsg);
		return _response;
		
	}
}
