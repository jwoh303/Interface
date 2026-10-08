package com.koreab2b.mro.common.coco.controller;

import java.io.OutputStream;
import java.util.ArrayList;
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

import com.koreab2b.mro.common.coco.service.CommonApprovalService;
import com.koreab2b.mro.common.coco.service.CommonMdCmBasePriceApprovalService;
import com.koreab2b.mro.common.coco.service.CommonMdCmBuyPriceApprovalService;
import com.koreab2b.mro.common.coco.service.CommonNgNsRcPaApprovalService;
import com.koreab2b.mro.common.coco.service.CommonPrPxApprovalService;
import com.koreab2b.mro.common.ibsheet.IBSheetUtil;
import com.koreab2b.mro.manager.login.domain.SessionInfo;
import com.koreab2b.mro.util.CommonUtil;

@Controller("CommonApprovalController")
public class CommonApprovalController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CommonApprovalController.class);

	@Autowired
	private CommonApprovalService commonApprovalService;
	@Autowired
	private CommonPrPxApprovalService commonPrPxApprovalService; 
	@Autowired
	private CommonNgNsRcPaApprovalService commonNgNsRcPaApprovalService;
	@Autowired
	private CommonMdCmBasePriceApprovalService commonMdCmBasePriceApprovalService;
	@Autowired
	private CommonMdCmBuyPriceApprovalService commonMdCmBuyPriceApprovalService;

	/**
	 *  결재대상조회
	 * @param pModel
	 * @param pMap
	 * @return
	 */
	@RequestMapping(value = "/buyerNewPassRecvList.do", method = RequestMethod.POST)
	public String buyerNewPassRecvList(HttpServletRequest request, ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());

		boolean getCauFlag = CommonUtil.getSpecialCheckReturn(_sessionInfo.getComCode(), "P06-0000107");
		boolean getMultiApprFlag = CommonUtil.getCode3CheckReturn("M-APPR", _sessionInfo.getUserId(), _sessionInfo.getComCode());
		
		if(getCauFlag == true){ // 중앙대 전용
			pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
			
			pMap.put("paging", "cnt"); // 전체 count 를 위한 구분
			String _total_cnt = CommonUtil.getListKeyValue(commonApprovalService.buyerCauNewPassRecvList(pMap),"TOTAL_CNT","0");
			
			pMap.put("paging", "nocnt");
			
			List<Map<String, String>> _data = commonApprovalService.buyerCauNewPassRecvList(pMap);
			
			pModel.addAttribute("total_cnt", _total_cnt);
			pModel.addAttribute("data", _data);
			pModel.addAttribute("CRUD", "R");
		
			return "common/approval/buyerCauNewPassRecvList";
		} else if(getMultiApprFlag == true) { // 멀티 결재 화면
			pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
			
			pMap.put("paging", "cnt"); // 전체 count 를 위한 구분
			String _total_cnt = CommonUtil.getListKeyValue(commonApprovalService.buyerNewPassRecvList(pMap),"TOTAL_CNT","0");
			
			pMap.put("paging", "nocnt");
			
			List<Map<String, String>> _data = commonApprovalService.buyerNewPassRecvList(pMap);
			
			pModel.addAttribute("total_cnt", _total_cnt);
			pModel.addAttribute("data", _data);
			pModel.addAttribute("CRUD", "R");
			
			return "common/approval/buyerNewMultiPassRecvList";
		} else {
			pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
			
			pMap.put("paging", "cnt"); // 전체 count 를 위한 구분
			String _total_cnt = CommonUtil.getListKeyValue(commonApprovalService.buyerNewPassRecvList(pMap),"TOTAL_CNT","0");
			
			pMap.put("paging", "nocnt");
			
			List<Map<String, String>> _data = commonApprovalService.buyerNewPassRecvList(pMap);
			
			pModel.addAttribute("total_cnt", _total_cnt);
			pModel.addAttribute("data", _data);
			pModel.addAttribute("CRUD", "R");
			
			return "common/approval/buyerNewPassRecvList";
		}
	}	
	
	/**
	 *  결재진행함
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/buyerNewPassCompleteList.do", method = RequestMethod.POST)
	public String buyerNewPassCompleteList(HttpServletRequest request, 
			ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());
		
		boolean getMultiApprFlag = CommonUtil.getCode3CheckReturn("M-APPR", _sessionInfo.getUserId(), _sessionInfo.getComCode());
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		pMap.put("paging", "cnt"); // 전체 count 를 위한 구분
		String _total_cnt = CommonUtil.getListKeyValue(commonApprovalService.buyerNewPassCompleteList(pMap),"TOTAL_CNT","0");
		
		pMap.put("paging", "nocnt"); 
		List<Map<String, String>> _data = commonApprovalService.buyerNewPassCompleteList(pMap);
		 
		
		pModel.addAttribute("total_cnt", _total_cnt);
		pModel.addAttribute("data", _data);
		pModel.addAttribute("CRUD", "R");
		
		if(getMultiApprFlag == true) { // 멀티 결재 화면
			return "common/approval/buyerNewMultiPassCompleteList";
		} else {
			return "common/approval/buyerNewPassCompleteList";
		}
	}
	// 리뉴얼 > 결재관리
	@RequestMapping(value = "/buyerNewPassList_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> buyerNewPassList_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {
		LOGGER.debug("buyerNewPassList_v2 요청 파라미터 : {}", pMap);
		
		pMap = IBSheetUtil.removeSlash(pMap);
		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());
		
		boolean getMultiApprFlag = CommonUtil.getCode3CheckReturn("M-APPR", _sessionInfo.getUserId(), _sessionInfo.getComCode());
		
		List<Map<String, String>> _data = commonApprovalService.buyerNewPassList_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	/**
	 *   결재상신함
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/buyerNewPassSendList.do", method = RequestMethod.POST)
	public String buyerNewPassSendList(HttpServletRequest request, 
			ModelMap pModel, @RequestParam Map<String, String> pMap) { 
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());
		
		pMap = CommonUtil.PagingPrc(pMap); // 페이징처리
		
		pMap.put("paging", "cnt"); // 전체 count 를 위한 구분
		String _total_cnt = CommonUtil.getListKeyValue(commonApprovalService.buyerNewPassSendList(pMap),"TOTAL_CNT","0");
		
		pMap.put("paging", "nocnt"); 
		List<Map<String, String>> _data = commonApprovalService.buyerNewPassSendList(pMap);
		 
		
		pModel.addAttribute("total_cnt", _total_cnt);
		pModel.addAttribute("data", _data);
		pModel.addAttribute("CRUD", "R");		
		
		return "common/approval/buyerNewPassSendList";
	}	
	
	
	/**
	 *   결재 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/approval/getCommonApprovalListPop.do", method = RequestMethod.POST)
	public String getCommonApprovalListPop(ModelMap pModel, @RequestParam Map<String, String> pMap) {
 
		 
		List<Map<String, String>> _data = commonApprovalService.getCommonApprovalListPop(pMap);		  
		pModel.addAttribute("data", _data);
		pModel.addAttribute("CRUD", "R");		
		
		return "common/popup/approval/"+pMap.get("VIEW");
	}
	@RequestMapping(value = "/common/approval/getCommonApprovalListPop_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCommonApprovalListPop_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		List<Map<String,String>> _data = commonApprovalService.getCommonApprovalListPop_v2(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	
	/**
	 *   결재문서 상세 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/approval/getBuyerCommonMyPagePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	@SuppressWarnings("unchecked")
	public String getBuyerCommonMyPagePop(
			HttpServletRequest request, 
			ModelMap pModel, 
			@RequestParam Map<String, String> pMap) {
 
		
		Map<String,Object> ht = new HashMap<String,Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());
		String comCode = _sessionInfo.getComCode();
		boolean p100000001 = CommonUtil.getSpecialCheckReturn(comCode,"P10-0000001");
		Map<String, Object> _data = commonApprovalService.getBuyerCommonMyPagePop(pMap);		  
		List<Map<String,String>> _dataList1 = (List<Map<String,String>>)_data.get("MYPAGE1");
		List<Map<String,String>> _dataList2 = (List<Map<String,String>>)_data.get("MYPAGE2");
		List<Map<String,String>> _dataList3 = (List<Map<String,String>>)_data.get("MYPAGE3");
		List<Map<String,String>> _dataList4 = (List<Map<String,String>>)_data.get("MYPAGE4");
		List<Map<String,String>> _dataList5 = (List<Map<String,String>>)_data.get("MYPAGE5");
		List<Map<String,String>> _dataList6 = (List<Map<String,String>>)_data.get("MYPAGE6");
		 
		if (_dataList1 == null || _dataList1.size() == 0){			
			ht.put("string_no","");
			ht.put("key_1","");
			ht.put("key_2","");
			ht.put("key_3","");
			ht.put("key_4","");
			ht.put("key_5","");
			ht.put("key_6","");
			ht.put("key_7","");
			ht.put("key_8","");
			ht.put("key_9","");
			ht.put("key_10","");
		}else{
			Map<String, String> _tmp  = _dataList1.get(0);
			ht.put("string_no" , _tmp.get("TEXT"));
			ht.put("key_1" , _tmp.get("KEY_1"));
			ht.put("key_2" , _tmp.get("KEY_2"));
			ht.put("key_3" , _tmp.get("KEY_3"));
			ht.put("key_4" , _tmp.get("KEY_4"));
			ht.put("key_5" , _tmp.get("KEY_5"));
			ht.put("key_6" , _tmp.get("KEY_6"));
			ht.put("key_7" , _tmp.get("KEY_7"));
			ht.put("key_8" , _tmp.get("KEY_8"));
			ht.put("key_9" , _tmp.get("KEY_9"));
			ht.put("key_10" , _tmp.get("KEY_10")); 
		}
		 
		 if (_dataList2 == null || _dataList2.size()==0){			 
			 LOGGER.debug("_dataList2 null");				
		 }else{
			 Map<String, String> _tmp  = _dataList2.get(0);
	         ht.put("user_id", _tmp.get("USER_ID"));
	         ht.put("start_date", _tmp.get("START_DATE"));
	         ht.put("subject", _tmp.get("DOCU_TITLE"));
	         ht.put("content", _tmp.get("DOCU_CONT"));
	         ht.put("docu_kn", _tmp.get("DOCU_KN"));
	         ht.put("docu_knName", _tmp.get("DOCU_KN_NAME"));
	         ht.put("cur_order_no",  _tmp.get("CUR_ORDER_NO"));
	         ht.put("pass_status",  _tmp.get("PASS_STATUS"));
	         ht.put("pass_status_text", _tmp.get("PASS_STATUS_TEXT"));
	         ht.put("extif_no",  _tmp.get("EXTIF_NO"));
	         ht.put("extif_count",  _tmp.get("EXTIF_COUNT"));
	         ht.put("extif_tp", _tmp.get("EXTIF_TP"));
	         ht.put("extif_tp_text", _tmp.get("EXTIF_TP_TEXT"));
	         ht.put("user_nm",_tmp.get("USER_NAME_LOC"));
	         ht.put("image_key",_tmp.get("IMAGE_KEY"));
	         ht.put("image_key_cnt",_tmp.get("IMAGE_KEY_CNT"));
	         ht.put("attach_file_list", _dataList5  );
	         ht.put("image_key_src",_tmp.get("IMAGE_KEY_FLAG"));
	         ht.put("biz_url",_tmp.get("TEXT2"));
	         ht.put("new_biz_url", _tmp.get("NEW_BIZ_URL")); //리뉴얼에서 쓰는 _v2붙은 url
	         ht.put("biz_jsp",_tmp.get("TEXT3"));
	         ht.put("action_base",_tmp.get("TEXT4"));
	         ht.put("approval_user_id",_tmp.get("APPROVAL_USER_ID"));
	         ht.put("approval_yn",_tmp.get("APPROVAL_YN"));
		 }
         ht.put("pass_ping", "0" );
         ht.put("pass_comp", "3" );
         
         
         
         String to = "";
         String cc = "";
         String ag = "";
         String kn;
 
         List<String[]> name_temp = new ArrayList<String[]>();
         StringBuilder toHtmlContent = new StringBuilder();
         int max_name     = 6;
         int max_position = 5; 
         
 
		 if (_dataList3 == null || _dataList3.size()==0){			
			 LOGGER.debug("_dataList3 null");				
		 }else{
			 for (int i=0; i<_dataList3.size(); i++) {
				 	 Map<String, String> _tmp  =_dataList3.get(i);
				 	 kn = _tmp.get("PASS_TP");
		             kn = kn.trim();
		             if ( kn.equals("1") ){
		                 to += CommonUtil.nvl(_tmp.get("USER_ID")) + ","; 
		             }else if ( kn.equals("3") ){
		                 ag += CommonUtil.nvl(_tmp.get("USER_ID")) + ",";
		                 to += "^" + CommonUtil.nvl(_tmp.get("USER_ID")) + ",";
		             }else{
		                 cc += CommonUtil.nvl(_tmp.get("USER_ID")) + ","; 
		             }             
		
		             String str[] = new String[9];
		
		             str[0] =  CommonUtil.nvl(_tmp.get("ORDER_NO"));  
		             str[1] =  CommonUtil.nvl(_tmp.get("PASS_TP_TEXT"));  
		             str[2] =  CommonUtil.nvl(_tmp.get("USER_NAME_LOC"))+"("+CommonUtil.nvl(_tmp.get("USER_ID")) +")";  
		             str[3] = CommonUtil.nvl(_tmp.get("POSITION"));  
		             str[4] = CommonUtil.nvl(_tmp.get("DEPARTMENT"));
		             str[5] = CommonUtil.nvl(_tmp.get("ORDR_NO"));
		             str[6] = CommonUtil.nvl(_tmp.get("DOCU_USER_ID"));
		             str[7] = CommonUtil.nvl(_tmp.get("PASS_TP"));
		             str[8] = CommonUtil.nvl(_tmp.get("CUR_ORDER_NO"));
		             if( max_name < str[2].length()){
		                 max_name = str[2].length();
		             }
		
		             if( max_position < str[3].length()){
		                 max_position = str[3].length();
		             }
		             name_temp.add(str);         
		         }
		
		 	 toHtmlContent.append("<table class='cont_t_list02'  style='width:100%'>");
	         for( int k =0 ; k < name_temp.size(); k++){
	             String user_info[] = name_temp.get(k); 
	             if(p100000001 == true){//결재 메일 전용 고객사일 경우 "결재요청메일 재발송" 기능 제거
	            	 toHtmlContent.append("<tr><td>"+user_info[0] + "</td><td>" + user_info[1] + "</td><td>"+ CommonUtil.replace_string( user_info[2] , max_name )  +"</td><td>"+ CommonUtil.replace_string( user_info[3] , max_position )  +"</td><td>"+ user_info[4] +"</td><td></td></tr>");
	             }else{
		             //결재타입이 결재이고 결재순서일 경우 결재요청 이메일 재발송 기능 활성화 처리
		              if( String.valueOf(user_info[7]).equals("1")  && String.valueOf(user_info[5]).equals(String.valueOf(user_info[8]))) 
		              {	
	            		  toHtmlContent.append("<tr><td>"+user_info[0]+"</td><td>"+  user_info[1] +"</td><td>"+  CommonUtil.replace_string( user_info[2] , max_name )  +"</td><td>"+  CommonUtil.replace_string( user_info[3] , max_position )  +"</td><td>"+  user_info[4] +"</td><td><a href=\"javascript:doMailSend('"+ user_info[5] +"','"+user_info[6]+"');\" style=color:blue>[결재요청메일 재발송]</a></td></tr>");
		              }else {
		            	  toHtmlContent.append("<tr><td>"+user_info[0] + "</td><td>" + user_info[1] + "</td><td>"+ CommonUtil.replace_string( user_info[2] , max_name )  +"</td><td>"+ CommonUtil.replace_string( user_info[3] , max_position )  +"</td><td>"+ user_info[4] +"</td><td></td></tr>");	            	  
		              } 	            	 
	             }
	         }
	         toHtmlContent.append("</table>");
		 }

         ht.put("to", CommonUtil.nvl(to));
         ht.put("cc", CommonUtil.nvl(cc));
         ht.put("ag", CommonUtil.nvl(ag));
         ht.put("toHtmlContent", toHtmlContent.toString());
     
         
         int iCount=0;
		 if (_dataList4 == null || _dataList4.size()==0){			
			 LOGGER.debug("_dataList4 null");				
		 }else{
			 for (int i=0; i<_dataList4.size(); i++) {
				 	 Map<String, String> _tmp  = _dataList4.get(i);
		             ht.put("file_nm" + iCount, CommonUtil.nvl(_tmp.get("FILE_NM")));  
		             ht.put("svrfile_nm" + iCount, CommonUtil.nvl(_tmp.get("SVRFILE_NM")));  
		             ht.put("file_size" + iCount, new Integer(CommonUtil.nvl(_tmp.get("FILE_SIZE"))) );
		             iCount++;
			 }
         }
         ht.put("attach_cnt", new Integer(iCount));
         
         StringBuilder sb = new StringBuilder();
		 if (_dataList6 == null || _dataList6.size()==0){			
			 LOGGER.debug("_dataList6 null");			
		 }else{
			 for (int i=0; i<_dataList6.size(); i++) {
				 Map<String, String> _tmp  = _dataList6.get(i);
				 sb.append("\n");
				 sb.append(CommonUtil.nvl(_tmp.get("USER_NAME_LOC")));
				 sb.append(" : " );
				 sb.append(CommonUtil.nvl(_tmp.get("PASS_ADD")));
			 }
		 }  
         ht.put("pass_add",sb.toString());  
         
		
		pModel.addAttribute("data", ht);
		pModel.addAttribute("CRUD", "R");		
		
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		if ("renewal".equals(uiVersion)) {
			String extif_tp = (String)ht.get("extif_tp");
			pMap.put("key_1", (String)ht.get("key_1"));
			pMap.put("extif_tp", extif_tp);
			pMap.put("pass_status_text", (String)ht.get("pass_status_text"));
			Map<String,Object> tmpData = new HashMap<String, Object>();
			if(extif_tp.equals("PR") || extif_tp.equals("PX")){
				tmpData = commonApprovalService.getBuyerCommonPrPxData(pMap);
			}else{
				tmpData = commonApprovalService.getBuyerCommonNgNsData(pMap);
			}
			ht.put("price", tmpData.get("PRICE")); //총 금액(결재대상금액)
			ht.put("rAmt", tmpData.get("R_AMT")); //반려금액
			ht.put("cnt",tmpData.get("CNT")); //품목수
			return "common/popup/approval/buyerCommonMyPagePop_v2";
		} else {
			return "common/popup/approval/buyerCommonMyPagePop";
		}
		
	}	
	
	/**
	 * 결재 처리 부분
	 *  PASS_KN 에 따라... 1 결재 3반려
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CommonApproval.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonApproval( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		  
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonApproval " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		
		String msg = commonApprovalService.approval(pMap);		  
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	/**
	 * 메일 발송 기능
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CommonApprovalMailSend.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> CommonApprovalMailSend( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		  
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());			
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonApprovalService.commonApprovalMailSend(pMap);		  
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	
	
	/**
	 *  일괄 결재 처리 부분
	 *  일괄 반려 처리 부분
	 *  PASS_KN 에 따라... 1 결재 3반려
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/AllCommonApproval.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> AllCommonApproval( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		  
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		String msg = "";
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonApproval " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_DEPT", _sessionInfo.getDepartment()); // 사용자부서
		pMap.put("USER_NAME", _sessionInfo.getUserNameLoc()); //사용자이름
		pMap.put("USER_TEL", _sessionInfo.getTel()); // 사용자전화번호
		
		
		
		Map<String, String> _map = new HashMap<String, String>();
		Map<String,String> map =  null;
		 List<Map<String,String>>  list =  null;
		String DOC_NAME =  "";
		String APPROVAL_TEXT = pMap.get("APPROVAL_TEXT");
		String[] approval_key = APPROVAL_TEXT.split("&&");
		if (approval_key != null){
			for (int i = 0; i<approval_key.length; i++){
				String[] approval_key2 = approval_key[i].split("@@");
				_map.put("COMPANY", approval_key2[0]);
				_map.put("DOCU_NO", approval_key2[1]);				
				list = commonApprovalService.getIcomTrgwList(_map); // 넘어온 값을 이용하여 대상을 조회하여
				if (list != null){
					map = list.get(0);
					DOC_NAME = map.get("DOC_NAME");
					map.put("PASS_KN", pMap.get("PASS_KN")); 
					map.put("PASS_ADD", pMap.get("PASS_ADD")); 
					map.put("USER_ID", pMap.get("USER_ID")); 
					map.put("USER_DEPT", pMap.get("USER_DEPT")); 
					map.put("USER_NAME", pMap.get("USER_NAME")); 
					map.put("USER_TEL", pMap.get("USER_TEL")); 
					//map.put("PASS_TP", pMap.get("DOC_NAME")); 
					map.put("DOCU_NO", map.get("TARGET")); 
					map.put("COMPANY", map.get("COM_CODE")); 
					map.put("DOC_TYPE", map.get("DOC_NAME")); 
					map.put("EXTIF_TP", map.get("DOC_NAME"));  
					map.put("DOCU_KN", "1");
					
					//SELECT * FROM ICOMCOD1 WHERE TYPE = 'APPR'
					if ("PR".equals(DOC_NAME) || "PX".equals(DOC_NAME) || "OF".equals(DOC_NAME) || "OE".equals(DOC_NAME) || "OEM".equals(DOC_NAME) ) {			
						msg = commonPrPxApprovalService.approval(map);
					}else if ("BP".equals(DOC_NAME) || "BPM".equals(DOC_NAME)) {
						msg = commonMdCmBasePriceApprovalService.approval(map);
					}else if ("SP".equals(DOC_NAME) || "SPM".equals(DOC_NAME)) {
						msg = commonMdCmBuyPriceApprovalService.approval(map);
					}else{
						String uiVersion = (String) request.getSession().getAttribute("uiVersion");
						if("renewal".equals(uiVersion)){
							msg = commonNgNsRcPaApprovalService.approval_v2(map);
						}else{
							msg = commonNgNsRcPaApprovalService.approval(map);
						}
					}
				}
				
			}
		}
		
		_msg.put("MSG", "OK"); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	
	
	/**
	 * 결재 반려 부분 -> commonApproval 이거 사용 PASS_KN 에 따라...
	 * 현재 메소드 사용안함
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CommonReject.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonReject( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonReject " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonApprovalService.reject(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	
	/**
	 * 결재 문서 수정
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/updateContent.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateContent( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("updateContent " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonApprovalService.updateContent(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	@RequestMapping(value ="/common/approval/updateContent_v2.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> updateContent_v2( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("updateContent " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonApprovalService.updateContent(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	
	@RequestMapping(value = "/common/approval/updatePassLine_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatePassLine_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		formData.put("COM_CODE", _sessionInfo.getComCode()); //고객사코드
		
		String rtnMsg = commonApprovalService.updatePassLine_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	@RequestMapping(value = "/common/approval/updatePassLine_v3.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> updatePassLine_v3(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		formData.put("COM_CODE", _sessionInfo.getComCode()); //고객사코드
		
		String rtnMsg = commonApprovalService.updatePassLine_v3(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	//결재선 추가
	@RequestMapping(value = "/common/approval/insertAppPath_v2.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertAppPath_v2(HttpServletRequest req, @RequestParam MultiValueMap<String, String> pMap) {
		Map<String, Object> _response = new HashMap<String, Object>();
		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		
		// gridData
		List<Object> gridData = CommonUtil.getMultiValueMapList(pMap); 
		// formData
		Map<String, String> formData = CommonUtil.getMultiValueMapMap(pMap);
		
		formData.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		formData.put("COM_CODE", _sessionInfo.getComCode()); //고객사코드
		
		String rtnMsg = commonApprovalService.insertAppPath_v2(formData, gridData);
		
		/* 성공시코드 1 , 실패시 0 */
		Map<String, Object> mp = new HashMap<String, Object>();
		mp.put("Code",1);
		mp.put("usrmsg","N");
		mp.put("msg", rtnMsg);
		mp.put("code", "100"); //재조회 하지 않기 위함
		mp.put("appPath", formData.get("APP_PATH"));
		_response.put("Result",mp);
		_response.put("Message", mp);
		return _response;
	}
	
	@RequestMapping(value ="/common/approval/deleteMyPassLine_v2.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> deleteMyPassLine_v2( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonApprovalService.deleteMyPassLine_v2(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	
	/**
	 * 상신 요청
	 * @param pMap
	 * @return
	 * @throws Exception
	 */ 
	@RequestMapping(value ="/common/approval/CommonRequest.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonRequest( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonRequest " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		
		String requesTemptYn = pMap.get("requesTemptYn").toString();
		String docu_no = "";
		
		if ("Y".equals(requesTemptYn)){
			docu_no = commonApprovalService.request_temp(pMap); //상신구현 필요		
		}else{
			docu_no = commonApprovalService.request(pMap); //상신구현 필요		
		}		  
	   
		_msg.put("DOCU_NO", docu_no); 
		_response.put("msg", _msg);
			
		return  _response;
	}
	 
	
	/**
	 * 상신 요청2 - 임시저장 ICOTDOCU	전자결재 임시저장	
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CommonRequestTemp.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonRequestTemp( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonRequest " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		
		
		String docu_no = commonApprovalService.request_temp(pMap); //상신구현 필요		  
	   
		_msg.put("DOCU_NO", docu_no); 
		_response.put("msg", _msg);
			
		return  _response;
	}
	
	
	
	/**
	 * 상신 취소
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/CommonCancel.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> commonCancel( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonCancel " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		
		String msg = commonApprovalService.cancel(pMap);		  
	  
		_msg.put("MSG", msg); 		
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	
	
	
	
	/**
	 *  업무상세샘플
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/popup/approval/approvalSamplePop.do", method = RequestMethod.GET)
	public String approvalBizView(ModelMap pModel, @RequestParam Map<String, String> pMap) {
		LOGGER.debug("approvalSamplePop 요청 파라미터 for jsp : {}", pMap);
		  
		/**
		 * 업무별상세구현
		 */
		 
		return  pMap.get("page"); // 업무별 상세 jsp 이동
	}	
	
	
	
	/**
	 *   결재 상신 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/approval/buyerCommonApprovalPop.do", method = RequestMethod.GET)
	@SuppressWarnings("unchecked")
	public String buyerCommonApprovalPop(
			HttpServletRequest request, 
			ModelMap pModel, 
			@RequestParam Map<String, String> pMap
			) {
 
		String uiVersion = (String) request.getSession().getAttribute("uiVersion");
		
		Map<String,Object> ht = new HashMap<String,Object>();		
		
		String st_title = CommonUtil.nvl((String) pMap.get("st_title"), "");
		String st_cont = CommonUtil.nvl((String) pMap.get("st_cont"), "");
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());
		
		if (pMap.get("DOC_TYPE") == null){
			pMap.put("DOC_TYPE","");
		} 
		pMap.put("COM_CODE", _sessionInfo.getComCode()); // 회사코드
		
		List<Map<String,String>> _dataList = new ArrayList<Map<String,String>>();
		if("renewal".equals(uiVersion)){
			_dataList = commonApprovalService.getApprovalLine_v2(pMap);
		}else{
			_dataList = commonApprovalService.getApprovalLine(pMap);		  // 결재라인 결재선
		}
		Map<String, Object> _data = commonApprovalService.getApprovalInfo(pMap);		  // 결재정보
		List<Map<String,String>> _dataList1 = (List<Map<String,String>>)_data.get("MYPAGE1"); 
		
		if (_dataList1 == null || _dataList1.size() == 0){			 
			 LOGGER.debug("_dataList1 null");			
		}else{
			Map<String, String> _tmp  = _dataList1.get(0);
	         ht.put("biz_url",_tmp.get("TEXT2"));
	         ht.put("new_biz_url",_tmp.get("TEXT6")); //리뉴얼용
	         ht.put("biz_jsp",_tmp.get("TEXT3"));
	         ht.put("action_base",_tmp.get("TEXT4"));
	         ht.put("curDate",_tmp.get("CURDATE"));
		}
		String st_category_no = CommonUtil.nvl((String) pMap.get("st_category_no"), "");
		pMap.put("st_category_no", st_category_no); // 회사코드
		List<Map<String,String>> _cateapprdataList = commonApprovalService.getCateApprovalLine(pMap);		  //카테고리담당자 

		List<Map<String,String>> _buyerapprdataList = commonApprovalService.getBuyerApprovalLine(pMap);		  // 고객사 별 결재 포함 필수
		
		pModel.addAttribute("approvalLine", _dataList);		
		pModel.addAttribute("data", ht);		
		pModel.addAttribute("CRUD", "R");
		pModel.addAttribute("st_title", st_title);
		pModel.addAttribute("st_cont", st_cont);
		pModel.addAttribute("cateapprovalLine", _cateapprdataList);
		pModel.addAttribute("buyerapprovalLine", _buyerapprdataList);
		
		if ("renewal".equals(uiVersion)) {
//			String extif_tp = pMap.get("DOC_TYPE");
//			pMap.put("key_1", (String)ht.get("key_1"));
//			pMap.put("extif_tp", extif_tp);
//			pMap.put("pass_status_text", (String)ht.get("pass_status_text"));
//			Map<String,Object> tmpData = new HashMap<String, Object>();
//			if(extif_tp.equals("PR") || extif_tp.equals("PX")){
//				tmpData = commonApprovalService.getBuyerCommonPrPxData(pMap);
//			}else{
//				tmpData = commonApprovalService.getBuyerCommonNgNsData(pMap);
//			}
//			ht.put("price", tmpData.get("PRICE")); //총 금액(결재대상금액)
//			ht.put("rAmt", tmpData.get("R_AMT")); //반려금액
//			ht.put("cnt",tmpData.get("CNT")); //품목수
			return "common/popup/approval/buyerCommonApprovalPop_v2";
		} else {
			return "common/popup/approval/buyerCommonApprovalPop";
		}
	}	
	
	
	
	
	/**
	 * 결재선에 관련된 결재정보
	 * @param pMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value ="/common/approval/getMultiPassLine.do", method = RequestMethod.POST) 
	@ResponseBody
	public  Map<String, Object> getMultiPassLine( 
			ModelMap pModel,  
			@RequestParam Map<String, String> pMap,
			 HttpServletRequest request) { 
		 
 
		Map<String, Object> _msg = new HashMap<String, Object>();
		Map<String, Object> _response = new HashMap<String, Object>();  
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		//System.out.println("commonRequest " +_sessionInfo.getUserId()); // 세션테스트		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		pMap.put("COM_CODE", _sessionInfo.getComCode()); // 회사코드
		
         String to = "";
         String cc = "";
         String ag = "";
	         String kn;
 
	         List<String[]> name_temp = new ArrayList<String[]>();
	         int max_name     = 6;
	         int max_position = 5; 
	         String gubun = ""; 
         StringBuilder toContent = new StringBuilder();
         StringBuilder toHtmlContent = new StringBuilder();
         
		List<Map<String,String>> _dataList = commonApprovalService.getMultiPassLine(pMap); //상신구현 필요		  			
		 if (_dataList == null || _dataList.size()==0){		
			 LOGGER.debug("_dataList null");			
		 }else{
			 for (int i=0; i<_dataList.size(); i++) {
				 	 Map<String, String> _tmp  =_dataList.get(i);
				 	 kn = _tmp.get("GUBUN");
		             kn = kn.trim();
		             //System.out.println(i  + "kn "+kn);
		             if ( kn.equals("C") ){
		                 to += CommonUtil.nvl(_tmp.get("APPR_ID")) + ","; 
		                 gubun = "to";
		             }else if ( kn.equals("H") ){
		            	 ag += CommonUtil.nvl(_tmp.get("APPR_ID")) + ","; 
		                 gubun = "ag";
		                 to += "^" + CommonUtil.nvl(_tmp.get("APPR_ID")) + ",";
		             }else{
		                 cc += CommonUtil.nvl(_tmp.get("APPR_ID")) + ","; 
		                 gubun = "cc";
		             }             
		             //System.out.println(i  + "to "+to);
		            // System.out.println(i  + "cc "+cc);
		             
		             String str[] = new String[5];
		
		             str[0] = String.valueOf( i+1);  
		             str[1] =  CommonUtil.nvl(_tmp.get("GUBUN_TEXT"));  
		             str[2] =  CommonUtil.nvl(_tmp.get("APPR_NAME"));  
		             str[3] = CommonUtil.nvl(_tmp.get("POSITION"));  
		             str[4] = CommonUtil.nvl(_tmp.get("DEPT"));  
		
		             if( max_name < str[2].length()){
		                 max_name = str[2].length();
		             }
		
		             if( max_position < str[3].length()){
		                 max_position = str[3].length();
		             }
		             name_temp.add(str);         
		             
		             toContent.append(gubun +"@"+CommonUtil.nvl(_tmp.get("APPR_ID"))+"@"+str[2]+"@"+str[3]+"@"+str[4]+"@$");
		         }
		
			 	 toHtmlContent.append("<table class='cont_t_list02'  style='width:100%'>");
		         for( int k =0 ; k < name_temp.size(); k++){
		             String user_info[] = name_temp.get(k); 
		
		//           String name_to = user_info[0] + "    " + user_info[1] + "      "+ replace_string( user_info[2] , max_name )  + "  "+ replace_string( user_info[3] , max_position )  + "  "+ user_info[4] ; 
		              if( String.valueOf(user_info[1]).equals("참조") ) // ??????????????
		              {
		            	  toHtmlContent.append("<tr><td>"+user_info[0] + "</td><td>" + user_info[1] + "</td><td>"+ CommonUtil.replace_string( user_info[2] , max_name )  +"</td><td>"+ CommonUtil.replace_string( user_info[3] , max_position )  +"</td><td>"+ user_info[4] +"</td></tr>");
		              }else {
		            	  toHtmlContent.append("<tr><td>"+user_info[0]+"</td><td>"+  user_info[1] +"</td><td>"+  CommonUtil.replace_string( user_info[2] , max_name )  +"</td><td>"+  CommonUtil.replace_string( user_info[3] , max_position )  +"</td><td>"+  user_info[4] +"</td><td>"+ "</td></tr>");
		              }
		
		              //sb.append(name_to );
		         }
		         toHtmlContent.append("</table>");
		 }

		 _msg.put("to", CommonUtil.nvl(to));
		 _msg.put("cc", CommonUtil.nvl(cc));
		 _msg.put("ag", CommonUtil.nvl(ag));
		 _msg.put("name_list", toHtmlContent.toString());
		 _msg.put("toContent", toContent.toString());
		 
		_response.put("msg", _msg);
		LOGGER.debug("_response " + _response);
			
		return  _response;
	}
	@RequestMapping(value = "/common/approval/getMultiPassLine_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getMultiPassLine_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		SessionInfo _sessionInfo = (SessionInfo) req.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());		
		pMap.put("USER_ID", _sessionInfo.getUserId()); // 사용자ID 
		pMap.put("USER_NM", _sessionInfo.getUserNameLoc()); // 사용자명
		pMap.put("COM_CODE", _sessionInfo.getComCode()); // 회사코드
		
		List<Map<String,String>> _data = commonApprovalService.getMultiPassLine_v2(pMap); //상신구현 필요
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	@RequestMapping(value = "/common/approval/getCurrentPassLine_v2.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getCurrentPassLine_v2(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		List<Map<String,String>> _data = commonApprovalService.getCurrentPassLine_v2(pMap); //상신구현 필요
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// EXCEL 다운로드	
	@RequestMapping(value = "/excelBuyerCauNewPassRecvList.do", method = RequestMethod.POST)
	public void excelBuyerCauNewPassRecvList(ModelMap pModel, HttpServletRequest req,@RequestParam Map<String, String> pMap, HttpServletResponse response, OutputStream outputStream) {
		// 조회일 슬래시 제거
		pMap = CommonUtil.removeSlash(pMap);
		
		// Excel Down을 위한 구분
		pMap.put("paging", "0"); 
		
		List<Map<String, String>> _data = commonApprovalService.buyerCauNewPassRecvExcelList(pMap); 
		
		String title = "";
		String headers = "";
		title = "요청번호|요청부서|요청자|요청일|구매요청제목|품목코드|품명|규격|단위|수량|단가|금액|납기요청일|예산부서|계정정보|도착지|첨부파일유무|";
		headers = "KEY1|ORDER_DEPT|USER_NM|START_DATE|DOCU_TITLE|BUYER_ITEM_NO|DESCRIPTION|SPECIFICATION|UNIT_MEASURE|TARGET_QTY|TARGET_PRICE|PRDT_AMT|RD_DATE|BUDGET_DEPT_TEXT|ACCOUNT_TYPE_TEXT|DELY_TO_LOCATION_TEXT|ATTACH_CNT|";			
		String excelHeader = title +"@@"+headers;
		
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader, "결재문서_엑셀다운로드.xls");
		 
	}
	
	/**
	 *   결재문서 상세 팝업
	 * @param pModel
	 * @param pMap
	 * @return
	 */	
	@RequestMapping(value = "/common/approval/getBuyerCauCommonMyPagePop.do", method = { RequestMethod.GET, RequestMethod.POST })
	@SuppressWarnings("unchecked")
	public String getBuyerCauCommonMyPagePop(
			HttpServletRequest request, 
			ModelMap pModel, 
			@RequestParam Map<String, String> pMap) {
 
		
		Map<String,Object> ht = new HashMap<String,Object>();
		
		SessionInfo _sessionInfo = (SessionInfo) request.getSession().getAttribute("sessionInfo");
		LOGGER.debug("로그인 사용자 아이디 : {}", _sessionInfo.getUserId());				
		pMap.put("USER_ID",_sessionInfo.getUserId());
		String comCode = _sessionInfo.getComCode();
		Map<String, Object> _data = commonApprovalService.getBuyerCauCommonMyPagePop(pMap);		  
		List<Map<String,String>> _dataList1 = (List<Map<String,String>>)_data.get("MYPAGE1");
		List<Map<String,String>> _dataList2 = (List<Map<String,String>>)_data.get("MYPAGE2");
		List<Map<String,String>> _dataList3 = (List<Map<String,String>>)_data.get("MYPAGE3");
		List<Map<String,String>> _dataList4 = (List<Map<String,String>>)_data.get("MYPAGE4");
		
		List<Map<String,String>> _dataList2_pr = (List<Map<String,String>>)_data.get("MYPAGE2_PR");
		List<Map<String,String>> _dataList4_pr = (List<Map<String,String>>)_data.get("MYPAGE4_PR");
		 
		if (_dataList1 == null || _dataList1.size() == 0){			
			ht.put("string_no","");
			ht.put("key_1","");
			ht.put("key_2","");
			ht.put("key_3","");
			ht.put("key_4","");
			ht.put("key_5","");
			ht.put("key_6","");
			ht.put("key_7","");
			ht.put("key_8","");
			ht.put("key_9","");
			ht.put("key_10","");
		}else{
			Map<String, String> _tmp  = _dataList1.get(0);
			ht.put("string_no" , _tmp.get("TEXT"));
			ht.put("key_1" , _tmp.get("KEY_1"));
			ht.put("key_2" , _tmp.get("KEY_2"));
			ht.put("key_3" , _tmp.get("KEY_3"));
			ht.put("key_4" , _tmp.get("KEY_4"));
			ht.put("key_5" , _tmp.get("KEY_5"));
			ht.put("key_6" , _tmp.get("KEY_6"));
			ht.put("key_7" , _tmp.get("KEY_7"));
			ht.put("key_8" , _tmp.get("KEY_8"));
			ht.put("key_9" , _tmp.get("KEY_9"));
			ht.put("key_10" , _tmp.get("KEY_10")); 
		}
		 
		 if (_dataList2 == null || _dataList2.size()==0){			 
			 LOGGER.debug("_dataList2 null");				
		 }else{
			 Map<String, String> _tmp  = _dataList2.get(0);
	         ht.put("user_id", _tmp.get("USER_ID"));
	         ht.put("start_date", _tmp.get("START_DATE"));
	         ht.put("subject", _tmp.get("DOCU_TITLE"));
	         ht.put("content", _tmp.get("DOCU_CONT"));
	         ht.put("docu_kn", _tmp.get("DOCU_KN"));
	         ht.put("docu_knName", _tmp.get("DOCU_KN_NAME"));
	         ht.put("cur_order_no",  _tmp.get("CUR_ORDER_NO"));
	         ht.put("pass_status",  _tmp.get("PASS_STATUS"));
	         ht.put("extif_no",  _tmp.get("EXTIF_NO"));
	         ht.put("extif_count",  _tmp.get("EXTIF_COUNT"));
	         ht.put("extif_tp", _tmp.get("EXTIF_TP"));
	         ht.put("user_nm",_tmp.get("USER_NAME_LOC"));
	         ht.put("image_key",_tmp.get("IMAGE_KEY"));
	         ht.put("attach_file_list", _dataList4  );
	         ht.put("image_key_src",_tmp.get("IMAGE_KEY_FLAG"));
	         ht.put("biz_url",_tmp.get("TEXT2"));
	         ht.put("biz_jsp",_tmp.get("TEXT3"));
	         ht.put("action_base",_tmp.get("TEXT4"));
	         ht.put("approval_user_id",_tmp.get("APPROVAL_USER_ID"));
		 }
		 
		 if (_dataList2_pr == null || _dataList2_pr.size()==0){			 
			 LOGGER.debug("_dataList2_pr null");				
		 }else{
			 Map<String, String> _tmp  = _dataList2_pr.get(0);
	         ht.put("pr_start_date", _tmp.get("START_DATE"));
	         ht.put("pr_subject", _tmp.get("DOCU_TITLE"));
	         ht.put("pr_content", _tmp.get("DOCU_CONT"));
	         ht.put("pr_image_key",_tmp.get("IMAGE_KEY"));
	         ht.put("pr_attach_file_list", _dataList4_pr  );
		 }
         ht.put("pass_ping", "0" );
         ht.put("pass_comp", "3" );
         
         String to = "";
         String cc = "";
         String ag = "";
         String kn;
 
         List<String[]> name_temp = new ArrayList<String[]>();
         StringBuilder toHtmlContent = new StringBuilder();
         int max_name     = 6;
         int max_position = 5; 
 
		 if (_dataList3 == null || _dataList3.size()==0){			
			 LOGGER.debug("_dataList3 null");				
		 }else{
			 for (int i=0; i<_dataList3.size(); i++) {
				 	 Map<String, String> _tmp  =_dataList3.get(i);
				 	 kn = _tmp.get("PASS_TP");
		             kn = kn.trim();
		             if ( kn.equals("1") ){
		                 to += CommonUtil.nvl(_tmp.get("USER_ID")) + ","; 
		             }else if ( kn.equals("3") ){
		                 ag += CommonUtil.nvl(_tmp.get("USER_ID")) + ",";
		                 to += "^" + CommonUtil.nvl(_tmp.get("USER_ID")) + ",";
		             }else{
		                 cc += CommonUtil.nvl(_tmp.get("USER_ID")) + ","; 
		             }             
		
		             String str[] = new String[9];
		
		             str[0] =  CommonUtil.nvl(_tmp.get("ORDER_NO"));  
		             str[1] =  CommonUtil.nvl(_tmp.get("PASS_TP_TEXT"));  
		             str[2] =  CommonUtil.nvl(_tmp.get("USER_NAME_LOC"))+"("+CommonUtil.nvl(_tmp.get("USER_ID")) +")";  
		             str[3] = CommonUtil.nvl(_tmp.get("POSITION"));  
		             str[4] = CommonUtil.nvl(_tmp.get("DEPARTMENT"));
		             str[5] = CommonUtil.nvl(_tmp.get("ORDR_NO"));
		             str[6] = CommonUtil.nvl(_tmp.get("DOCU_USER_ID"));
		             str[7] = CommonUtil.nvl(_tmp.get("PASS_TP"));
		             str[8] = CommonUtil.nvl(_tmp.get("CUR_ORDER_NO"));
		             if( max_name < str[2].length()){
		                 max_name = str[2].length();
		             }
		
		             if( max_position < str[3].length()){
		                 max_position = str[3].length();
		             }
		             name_temp.add(str);         
		         }
		
		 	 toHtmlContent.append("<table class='cont_t_list02'  style='width:100%'>");
	         for( int k =0 ; k < name_temp.size(); k++){
	             String user_info[] = name_temp.get(k); 
            	 toHtmlContent.append("<tr><td>"+user_info[0] + "</td><td>" + user_info[1] + "</td><td>"+ CommonUtil.replace_string( user_info[2] , max_name )  +"</td><td>"+ CommonUtil.replace_string( user_info[3] , max_position )  +"</td><td>"+ user_info[4] +"</td><td></td></tr>");
	         }
	         toHtmlContent.append("</table>");
		 }
		 
         ht.put("to", CommonUtil.nvl(to));
         ht.put("cc", CommonUtil.nvl(cc));
         ht.put("ag", CommonUtil.nvl(ag));
         ht.put("toHtmlContent", toHtmlContent.toString());
         ht.put("passUserSize", name_temp.size());
         
		pModel.addAttribute("data", ht);
		pModel.addAttribute("CRUD", "R");		
		
		return "common/popup/approval/buyerCauCommonMyPagePop";
	}
	
	// 조회
	@RequestMapping(value = "/common/approval/getBuyerCauCommonMyPagePopPrList.do",  method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public Map<String, Object> getBuyerCauCommonMyPagePopPrList(HttpServletRequest req, @RequestParam Map<String, Object> pMap) {

		//페이징용 파라미터의 셋팅
		pMap = IBSheetUtil.addParamForPaging3(pMap);

		List<Map<String,String>> _data = commonApprovalService.getBuyerCauCommonMyPagePopPrList(pMap);
		
		return IBSheetUtil.addResut(req, _data , pMap);
	}
	
	// EXCEL 다운로드(카탈로그 계약변경 일괄수정)	
	@RequestMapping(value = "/common/approval/excelDownCamListPop.do", method = RequestMethod.POST)
	public void excelDownCamListPop(ModelMap pModel, HttpServletRequest req, @RequestParam Map<String, String> pMap
			, HttpServletResponse response
			, OutputStream outputStream    ) {
		
		List<Map<String, String>> _data = commonApprovalService.getExcelDownCamList(pMap);  

		String title = "";
		String headers = "";
		
			title = "구매사명|품목코드|품목명|규격|단위|기존협력사|변경협력사|기존매출가|변경매출가|매출단가변동율|기존매입가|변경매입가|매입단가변동율|기존매익율|변경매익율|"
					+ "매익율GAP|기존품목구분|변경품목구분|기존표준납기일|변경표준납기일|기존매출단가유효일|변경매출단가유효일|기존매입단가유효일|변경매입단가유효일|기존MOQ|변경MOQ|"
					+ "기존발주배수|변경발주배수|기존거래유형|변경거래유형|기존물류센터|변경물류센터|계약서번호|계약서항번";
			headers = "BUYER_NAME|BUYER_ITEM_NO|RE_DESCRIPTION|RE_SPECIFICATION|RE_UNIT_MEASURE|RE_AGENT_TEXT|CH_AGENT_TEXT|"
					+ "RE_UNIT_PRICE|CH_UNIT_PRICE|UNIT_PRICE_RATE|RE_LIST_PRICE|CH_LIST_PRICE|LIST_PRICE_RATE|RE_RATE|CH_RATE|RATE_GAP|"
					+ "RE_ITEM_MAKE_TYPE_NM|CH_ITEM_MAKE_TYPE_NM|RE_DELIVERY_LT|CH_DELIVERY_LT|RE_SELL_CLOSE_DATE|CH_SELL_CLOSE_DATE|"
					+ "RE_BUY_CLOSE_DATE|CH_BUY_CLOSE_DATE|RE_MIN_ORDER_QTY|CH_MIN_ORDER_QTY|RE_PUR_UNIT_QTY|CH_PUR_UNIT_QTY|"
					+ "RE_PROCESS_TYPE_TEXT|CH_PROCESS_TYPE_TEXT|RE_WAREHOUSE_CODE_TEXT|CH_WAREHOUSE_CODE_TEXT|CONTRACT_NO|CONTRACT_SEQ|";			
		
		
		String pmNo = pMap.get("KEY_1"); 
		String excelHeader = title +"@@"+headers;
		CommonUtil.downloadExcel(_data, response, outputStream, excelHeader ,"카탈로그계약변경일괄수정_"+pmNo+".xls");
		 
	}
	
}
