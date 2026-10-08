package com.koreab2b.mro.common.coco.dao;

import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.formula.functions.Replace;
import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibleaders.ibsheet7.util.Common;
import com.koreab2b.mro.util.CommonUtil;

@Repository("commonApprovalDao")
@Transactional
public class CommonApprovalDaoImpl implements CommonApprovalDao {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonApprovalDaoImpl.class);

    public final static String MAN_SEND = "0";      //결재유형 - 기안자
	public final static String MAN_PASS = "1";  // 결재유형 - 결재자
	public final static String MAN_REFER = "2"; // 결재유형 - 참조자
	public final static String MAN_AGREE = "3"; // 결재유형 - 합의자
	// 결재상태
	public final static String STATUS_TEMP = "9";   // 임시 저장
	public final static String STATUS_PING = "0";   // 결재상태 - 결재중
	public final static String STATUS_RET = "1";    // 결재상태 - 반려
	public final static String STATUS_RING = "2";   // 결재상태 - 참조진행
	public final static String STATUS_COMP = "3";   // 결재상태 - 결재완료
	// 결재종류
	public final static String KIND_SEND = "0";     // 결재종류 - 기안
	public final static String KIND_PASS = "1";     // 결재종류 - 결재
	public final static String KIND_REFER = "2";    // 결재종류 - 참조
	public final static String KIND_RET = "3";      // 결재종류 - 반려
	public final static String KIND_AGREE = "4";    // 결재종류 - 합의

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate; 
 
	public List<Map<String,String>> buyerNewPassRecvList(Map<String,String>  _pMap) {
		return sqlSessionTemplate.selectList("commonApproval.buyerNewPassRecvList",_pMap);
	} 
	public List<Map<String,String>> buyerNewPassCompleteList(Map<String,String>  _pMap)  {
		return sqlSessionTemplate.selectList("commonApproval.buyerNewPassCompleteList",_pMap);
	} 
	public List<Map<String,String>>  buyerNewPassSendList(Map<String,String>  _pMap) {
		return sqlSessionTemplate.selectList("commonApproval.buyerNewPassSendList",_pMap);
	}
	public List<Map<String,String>> buyerNewPassList_v2(Map<String,Object>  _pMap)  {
		return sqlSessionTemplate.selectList("commonApproval.buyerNewPassList_v2",_pMap);
	} 
	public List<Map<String,String>>  getCommonApprovalListPop(Map<String,String>  _pMap) {
		return sqlSessionTemplate.selectList("commonApproval."+_pMap.get("VIEW"),_pMap);
	}
	public List<Map<String,String>>  getCommonApprovalListPop_v2(Map<String,Object>  _pMap) {
		return sqlSessionTemplate.selectList("commonApproval."+_pMap.get("VIEW"),_pMap);
	}
	 public Map<String,Object>  getBuyerCommonMyPagePop(Map<String,String>  _pMap) {
		 
		 Map<String,Object> _map = new HashMap<String,Object>();
		 String PASS_TP = _pMap.get("PASS_TP").toString();
		 
		 /**
		  * 상태 수정
		  */
		 if ( "2".equals(PASS_TP) ){
			 sqlSessionTemplate.update("commonApproval.modfiySetRefer1",_pMap);
		 }else{
			 sqlSessionTemplate.update("commonApproval.modfiySetRefer2",_pMap);
		 }
		 
		 _map.put("MYPAGE1", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage1",_pMap));
		 _map.put("MYPAGE2", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage2",_pMap));
		 _map.put("MYPAGE3", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage3",_pMap));
		 _map.put("MYPAGE4", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage4",_pMap));
		 _map.put("MYPAGE5", sqlSessionTemplate.selectList("commonApproval.getAttachFileDataBaseSelect",_pMap));
		 _map.put("MYPAGE6", sqlSessionTemplate.selectList("commonApproval.getPassAdd",_pMap));
		 
		 return _map;
	 }
	 
	 public Map<String,Object>  getBuyerCommonPrPxData(Map<String,String>  _pMap) {
		 return sqlSessionTemplate.selectOne("commonApproval.getBuyerCommonPrPxData",_pMap);
	 }
	 public Map<String,Object>  getBuyerCommonNgNsData(Map<String,String>  _pMap) {
		 return sqlSessionTemplate.selectOne("commonApproval.getBuyerCommonNgNsData",_pMap);
	 }
	 
	 
	 /**
	  * PASS_KN 결재 1
	  * PASS_KN 반려 3
	  */
	 @Transactional
	 public String approval(Map<String, String> _pMap) {
		 //결재 반려
		 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.js
		 ///kr/customer/common/popup/pop_pass/mp_market_mybiz_pass_cancel.jsp
		 String ORDER_NO = "";
		 String pass_status = "";
		 try{
		 // 1. 외부 Interface 필드 가져오기
		 Map<String, String> _map = sqlSessionTemplate.selectOne("commonApproval.getApprovalProcess",_pMap);
		 //System.out.println("_map " +_map);
		// 2. 결재종류 설정하기
		 sqlSessionTemplate.update("commonApproval.modifyICOGPASSLN",_pMap); // 결재라인 수정
		 
		 // 3. 다음 결재자 가져오기
         int cur_order_no = 0;   // 더이상 결재자가 없는 경우 최종결재자 순서로.
         pass_status = STATUS_PING;   // 결재중
         // 반려가 아닌경우 다음결재자 가져오기
         if(KIND_PASS .equals(_pMap.get("PASS_KN")) ){ // 결재
        	 
        	 //_pMap.put("PASS_TP", MAN_PASS); // 결재자 
        	 List<Map<String,String>> _list_order_no = sqlSessionTemplate.selectList("commonApproval.getICOGPASSLNOrderNo",_pMap); // 결재라인 정보 조회 - 결재안된 결재자 조회
        	 
        	 if (_list_order_no == null){        		 
        		 pass_status = STATUS_COMP; // 결재상태 - 결재완료
        	 }else{
        		 if (_list_order_no.size()>0){
	        		 Map<String, String>  _map_order_no = _list_order_no.get(0);
	        		 if (_map_order_no == null){        			
	        			 pass_status = STATUS_COMP;
	        		 }else{
	        			 ORDER_NO = _map_order_no.get("ORDER_NO").toString();     
	        			// System.out.println("ORDER_NOORDER_NOORDER_NO " +ORDER_NO); 

		                 if("".equals(ORDER_NO)){
		                	 pass_status = STATUS_COMP;
		                 }else{
		                	 cur_order_no = Integer.parseInt(ORDER_NO);
		                 }
	        		 }
        		 }else{
        			 pass_status = STATUS_COMP;
        		 }
        	 } 
        	 //System.out.println("_map_order_no " +cur_order_no); 

         }else{
             pass_status = STATUS_RET; // 반려
         }
         //System.out.println("pass_status " +pass_status);
         //System.out.println("cur_order_no " +cur_order_no);
         
		 // 4. Wisehub Interface  업무 처리
         _pMap.put("DOC_NAME", _map.get("EXTIF_TP").toString());

		 // 5. 결재순위 및 결재상태 설정
         _pMap.put("PASS_STATUS", pass_status);
         _pMap.put("CUR_ORDER_NO", String.valueOf(cur_order_no));
         if ( !pass_status.equals(STATUS_PING) ){ // 결재중이 아니면 
        	 sqlSessionTemplate.update("commonApproval.modifyICOGDOCU1",_pMap); // 최종처리
         } else {
        	 sqlSessionTemplate.update("commonApproval.modifyICOGDOCU2",_pMap); // cur_order_no 결재 순위 처리
    
	 	}
         
         LOGGER.debug("pass_statuspass_statuspass_statuspass_statuspass_statuspass_statuspass_statuspass_status  {} " , pass_status);		
		 }catch(Exception e){
				throw new RuntimeException();
		 }
         return pass_status;
		 
	 }
		
	 /**
	  * 결재 메일 재발송
	  */
	 @Transactional
	 public String commonApprovalMailSend(Map<String, String> _pMap) {
		 // 결재 메일 재발송
		 sqlSessionTemplate.update("commonApproval.insertApprovalMailSend",_pMap);
 		return "OK";
	 }
	 /**
	  * 결재 수정 , 변경
	  */
	 @Transactional
	 public String updateContent(Map<String, String> _pMap) {
		 ///kr/customer/common/popup/pop_pass/buyer_common_pass_change.jsp
		 // 변경 수정
		 
		 _pMap.put("PASS_KN", KIND_SEND);     
		 _pMap.put("PASS_TP", MAN_SEND);
         
		 // 내용 수정
		 sqlSessionTemplate.update("commonApproval.modifyICOGDOCU_DOCU_CONT",_pMap);
		 
		 // 결재라인 등록
		 String _to_str[]		= _pMap.get("to").trim().split(",");   		 
		 String _cc_str[]		= _pMap.get("cc").trim().split(",");
		 
		 Map<String, Object> _data = new HashMap<String, Object>(); 			
		 _data.put("COMPANY", _pMap.get("COMPANY"));
 		 _data.put("DOCU_NO", _pMap.get("DOCU_NO"));
 		 _data.put("PASS_KN", _pMap.get("PASS_KN"));
			
 		approvalList(_to_str,_cc_str,_data,"MOD");
 		
 		return "OK";
	 }
	 @Transactional
	 public String updateContent_v2(Map<String, String> _pMap) {
		 ///kr/customer/common/popup/pop_pass/buyer_common_pass_change.jsp
		 // 변경 수정
		 
		 _pMap.put("PASS_KN", KIND_SEND);     
		 _pMap.put("PASS_TP", MAN_SEND);
         
		 // 내용 수정
		 sqlSessionTemplate.update("commonApproval.modifyICOGDOCU_DOCU_CONT",_pMap);
		 
 		return "OK";
	 }
	 
	 /**
	  * 결재  라인등록
	  * @param _to_str
	  * @param _cc_str
	  * @param _data
	  * @param mode
	  * 
	  * 
	  * asis : updatePassLn
	  */
	 public void approvalList(String []_to_str,String []_cc_str,Map<String, Object> _data,String mode){
		 
		 
         if ( mode.equals("NEW") ){  // 기안자 등록하기
	             // 기안자 등록하기
        	    //	_data.put("USER_ID", user_id); 
            	 _data.put("PASS_KN", KIND_SEND);       // 기안자 => 결재
            	 _data.put("PASS_TP", MAN_SEND);  
	             sqlSessionTemplate.update("commonApproval.createICOGPASSLN",_data);  
	             
         }else if ( mode.equals("MOD") ){ // 결재선 수정인 경우
			 // 결재라인 전체삭제
			 sqlSessionTemplate.update("commonApproval.removeICOGPASSLN",_data);
         }
		 
		 for(int i=0 ; i < _to_str.length; i++){
				if ("".equals(_to_str[i])){
					 LOGGER.debug("_to_str[i] null");
				}else{
					checkApprUserId(_to_str[i].replace("^", ""));
					if(_to_str[i].substring(0, 1).equals("^")){ // 합의자
						_data.put("USER_ID", _to_str[i].replace("^", ""));
						_data.put("PASS_TP", MAN_AGREE);
					}else{ // 결재자
						_data.put("USER_ID", _to_str[i]);
						_data.put("PASS_TP", MAN_PASS);
					}
					
					if ( i == 1 )  {
						_data.put("PASS_KN", _data.get("PASS_KN")); 
					}else{
						_data.put("PASS_KN", ""); 
					}
					sqlSessionTemplate.update("commonApproval.createICOGPASSLN",_data);
				}
			}
			 
			for(int i=0 ; i < _cc_str.length; i++){
				if ("".equals(_cc_str[i])){
					 LOGGER.debug("_cc_str[i] null");
				}else{
					checkApprUserId(_cc_str[i]);
					_data.put("USER_ID", _cc_str[i]);
					_data.put("PASS_TP", MAN_REFER);
					if ( i == 1 )  {
						_data.put("PASS_KN", _data.get("PASS_KN"));
					}else{
						_data.put("PASS_KN", "");
					}
					sqlSessionTemplate.update("commonApproval.createICOGPASSLN",_data);
				}
			}
	 }

	 private void checkApprUserId(String userId){
		 String _userId = CommonUtil.nvl(userId).trim();
		 if ("".equals(_userId) || "undefined".equalsIgnoreCase(_userId) || "null".equalsIgnoreCase(_userId)) {
			 LOGGER.error("createICOGPASSLN 결재자 ID 오류 : [" + userId + "]");
			 throw new RuntimeException("결재선의 결재자 정보가 올바르지 않습니다. 결재선을 다시 지정해 주세요.");
		 }
	 }
	 
	 
	 /**
	  * 
	  * 결재 상신 요청을 취소한다.
	  */
	 @Transactional
	 public String cancel(Map<String, String> _pMap) {
		 // 상신 취소 
		 ///kr/customer/common/popup/pop_pass/buyer_common_pass_change.jsp
		 
         /**
          * 
          * 상신 취소
          * 구현 필요 
          * --------------------------------------
          * 구현 필요
          * 
          */
		 /*
		  * 
		  * RECV_FLAG,'GS','결재중','
			PS','결재중','
			GR','결재반려','
			PR','결재반려','
			RR','요청반려','
			GA','발주대기','
			PT','발주대기',
			'PD','상신취소',
			'GD','상신취소', 

		if(gw_flag.equals("PS")) {
			gw_result = isUpdateGWRollBack(company, docu_no);
		}
			
         if(doc_name.equals("PX"))
         {
             icomprdt_query="UPDATE ICOMPRDT SET RECV_FLAG='PD' WHERE BUYER='"+company+"' AND REF_NO='"+ref_no+"'";
         }else if(doc_name.equals("NS"))
         {
             icomprdt_query="UPDATE KEPRQDT SET RECV_FLAG='GA' WHERE BUYER='"+company+"' AND GW_NO='"+ref_no+"'";
         }else {
             icomprdt_query="UPDATE ICOMPRDT SET RECV_FLAG='GD' WHERE BUYER='"+company+"' AND PR_NO='"+ref_no+"'";
         }
         */
         
		 // 결재라인 등록
		 String _to_str[]		= _pMap.get("to").trim().split(",");   		 
		 String _cc_str[]		= _pMap.get("cc").trim().split(",");
		 
		 Map<String, Object> _data = new HashMap<String, Object>(); 			
		 _data.put("COMPANY", _pMap.get("COMPANY"));
 		 _data.put("DOCU_NO", _pMap.get("DOCU_NO"));
 		 _data.put("PASS_KN", _pMap.get("PASS_KN"));
			
 		//approvalList(_to_str,_cc_str,_data,"MOD");

		 sqlSessionTemplate.update("commonApproval.modifyICOGDOCU_PASSSTATUS",_pMap);
		 sqlSessionTemplate.update("commonApproval.modifyICOGPASSLN_PASSKN",_pMap);
		 
		 return "OK";
	 }
	 
	 
 
	 public String request(Map<String, String> _pMap) {
		 /* 상신 요청 공통 구현 */
		 // /kr/customer/common/popup/pop_pass/buyer_pass_post.jsp
		 //setTempPassBase - ejb
 
		 _pMap.put("DOC_TYPE_ICOMTRGW", _pMap.get("DOC_TYPE")); // 결재중		 
		 _pMap.put("DOC_TYPE", "GW"); // 결재중
		 
		 String DOCU_NO = "";
		 if (_pMap.get("DOCU_NO") == null || "".equals(_pMap.get("DOCU_NO"))){
			 
			
			 LOGGER.debug("DOCU_NO X ");
			 /*
			 // DOCU_NO 존재여부 판단 
			 Map<String, String> _map1 = sqlSessionTemplate.selectOne("commonApproval.getDocuNoICOMSQMT",_pMap);
			 if (_map1 == null || "".equals(_map1.get("DOCU_NO").toString())){
				 sqlSessionTemplate.update("commonApproval.createICOMSQMT",_pMap); 			  // 없을경우 insert
			 }else{
				 sqlSessionTemplate.update("commonApproval.modifyICOMSQMT",_pMap); 			 // 존재시 +1 update
			 }
			 
			 // 최종 DOCU_NO 를 구한다.
			 Map<String, String> _map2 = sqlSessionTemplate.selectOne("commonApproval.getDocuNoICOMSQMT",_pMap);
			 if (_map2 == null || "".equals(_map2.get("DOCU_NO").toString())){	 
				 LOGGER.debug("DOCU_NO null");		
			 }else{
				 DOCU_NO = _map2.get("DOCU_NO").toString();
			 } 
			 */
			 
			 DOCU_NO = getOrderNo(_pMap.get("COMPANY"),"GW");
			 			 
			 //DOCU_NO = _pMap.get("DOCU_NO").toString(); 
			 //DOCU_NO = getOrderNo(_pMap.get("COMPANY").toString(),"GW"); // 결재번호 생성 
			 
		 }else{
			 
			 LOGGER.debug("DOCU_NO O {} " , _pMap.get("DOCU_NO"));
			 
		 }
		 
		 LOGGER.debug("DOCU_NO result {} " , _pMap.get("DOCU_NO"));
		 //System.out.println("DOCU_NODOCU_NODOCU_NODOCU_NO  "+DOCU_NO);
		 _pMap.put("DOCU_NO", DOCU_NO);		 // DOCU_NO
		 _pMap.put("PASS_STATUS", STATUS_PING); // 결재중
		 //_pMap.put("st_image_key", ""); 
		 sqlSessionTemplate.update("commonApproval.createICOGDOCU",_pMap); //결재문서 정보
		 
		 /** 파일업로드 테이블 Y 로 변경*/
	        //첨부파일 유효성 활성화(GABAGE_FLAG 를 'Y' 로 변경)  
	        Map<String,String> _fildData = new HashMap<String,String>() ; 
	        _fildData.put("DOC_NO", _pMap.get("st_image_key"));
	        sqlSessionTemplate.update("common.fileUploadFlagUpdate", _fildData);
		 
		 String BIZ_DOCU_NO = CommonUtil.nvl(_pMap.get("BIZ_DOCU_NO"), "null");  // 업무에서 만들어진 업무의키		 
		 /**
		  * 추후 연계 작업을 위해 업무에서 집어넣어야 합니다.
		  */		 
		 String KEY_1 = CommonUtil.nvl(_pMap.get("KEY_1"), BIZ_DOCU_NO);  // 업무의키 <-- 반드시 있어야 한다.
		 String KEY_2 = CommonUtil.nvl(_pMap.get("KEY_2"), " ");
		 String KEY_3 = CommonUtil.nvl(_pMap.get("KEY_3"), " ");
		 String KEY_4 = CommonUtil.nvl(_pMap.get("KEY_4"), " ");
		 String KEY_5 = CommonUtil.nvl(_pMap.get("KEY_5"), " ");
		 String KEY_6 = CommonUtil.nvl(_pMap.get("KEY_6"), " ");
		 String KEY_7 = CommonUtil.nvl(_pMap.get("KEY_7"), " ");
		 String KEY_8 = CommonUtil.nvl(_pMap.get("KEY_8"), " ");
		 String KEY_9 = CommonUtil.nvl(_pMap.get("KEY_9"), " ");
		 String KEY_10 = CommonUtil.nvl(_pMap.get("KEY_10"), " ");		 
		  
		 /*
		  * ICOMTRGW createICOMTRGW <-- 추후 업무에서 연결고리로 사용하는 테이블
		  * ICOTDOCU	전자결재 임시저장  
		  */
		 _pMap.put("KEY_1",KEY_1); // 업무의키 <-- 반드시 있어야 한다.
		 _pMap.put("KEY_2",KEY_2); //KEY_2
		 _pMap.put("KEY_3",KEY_3); //KEY_3
		 _pMap.put("KEY_4",KEY_4); //KEY_4
		 _pMap.put("KEY_5",KEY_5); //KEY_5
		 _pMap.put("KEY_6",KEY_6); //KEY_6
		 _pMap.put("KEY_7",KEY_7); //KEY_7
		 _pMap.put("KEY_8",KEY_8); //KEY_8
		 _pMap.put("KEY_9",KEY_9); //KEY_9
		 _pMap.put("KEY_10",KEY_10); //KEY_10
		 
		 //표준카탈로그 등록시 필요한 로직. 예외사항.
		 if(CommonUtil.nvl(_pMap.get("DOC_TYPE_ICOMTRGW"), " ").equals("SCA")){
			 sqlSessionTemplate.update("commonMdCmStndApproval.updateMdcmStndCmscatlgAdd",_pMap);
		 }
		 //
		 sqlSessionTemplate.update("commonApproval.createICOMTRGW",_pMap); 
		 
		 
		 // 결재라인 등록
		 String _to_str[]		= _pMap.get("to").trim().split(",");   		 
		 String _cc_str[]		= _pMap.get("cc").trim().split(",");
		 Map<String, Object> _data = new HashMap<String, Object>(); 			
		 _data.put("COMPANY", _pMap.get("COMPANY"));
 		 _data.put("DOCU_NO", _pMap.get("DOCU_NO"));
 		 _data.put("PASS_KN", _pMap.get("PASS_KN"));
 		 _data.put("USER_ID", _pMap.get("USER_ID"));
	 	 approvalList(_to_str,_cc_str,_data,"NEW");
	 	 
	 	 return DOCU_NO;
	 }
	 
	 @Transactional
	 public String request_temp(Map<String, String> _pMap) {
		 /* 상신 요청 공통 구현 */
		 // /kr/customer/common/popup/pop_pass/buyer_pass_post.jsp
		 //setTempPassBase - ejb

		 String DOCU_NO = getOrderNo(_pMap.get("COMPANY").toString(),"TM");
	 	 
		 _pMap.put("DOCU_NO", DOCU_NO);		 // DOCU_NO 
		 _pMap.put("PASS_STATUS", STATUS_TEMP);  // 임시 저장 
		 sqlSessionTemplate.update("commonApproval.createICOTDOCU",_pMap); 
	 	 
	 	 return DOCU_NO;
		 
	 }
	 
	 
		//채번
		public String getOrderNo(String cmpyId, String docType) 
		{
			String returnValue = null;
			Map<String, String>  pMap = new HashMap<String, String>();
			
			pMap.put("COM_CODE", cmpyId);
			pMap.put("DOC_TYPE", docType);
			try {
				returnValue = sqlSessionTemplate.selectOne("common.getDocuNo", pMap);
				LOGGER.debug("채번 - returnValue : {}  " , returnValue);
				
				if (returnValue == null || "".equals(returnValue) ||  returnValue.isEmpty()){
					sqlSessionTemplate.insert("common.insertDocuNo", pMap);
					
					String year = "0" + Calendar.getInstance().get(Calendar.YEAR );
					returnValue = docType +year.substring(2,4) + "000001";
				} else {
					sqlSessionTemplate.update("common.updateDocuNo", pMap);
				}
				LOGGER.debug("채번 - returnValue :  {}  " ,  returnValue);
				
			} catch (Exception e){
				LOGGER.debug("채번 Exception : ", e);
				throw new RuntimeException( "채번 취득에 실패하였습니다.");
			} finally {
				LOGGER.debug("채번 - returnValue :  {}  " ,  returnValue);
			}
			return returnValue;
		}
		
		
		
	 
	 
	 @Transactional
	 public void test(Map<String, String> _pMap) {
		 sqlSessionTemplate.update("commonApproval.test",_pMap); 
	 }
	 
	 @Transactional
	 public void test1(Map<String, String> _pMap) { 
		 sqlSessionTemplate.update("commonApproval.test1",_pMap); 
	 }
	 
		public List<Map<String,String>>   getApprovalLine(Map<String,String>  _pMap) { 
			 return sqlSessionTemplate.selectList("commonApproval.getApprovalLine",_pMap); 
		}
		public List<Map<String,String>>   getApprovalLine_v2(Map<String,String>  _pMap) { 
			 return sqlSessionTemplate.selectList("commonApproval.getApprovalLine_v2",_pMap); 
		}
		public Map<String,Object>  getApprovalInfo(Map<String,String>  _pMap) {
			 Map<String,Object> _map = new HashMap<String,Object>(); 			 
			 _map.put("MYPAGE1", sqlSessionTemplate.selectList("commonApproval.getApprovalInfo1",_pMap)); 
			 return _map;
		}

		public List<Map<String,String>>   getCateApprovalLine(Map<String,String>  _pMap) { 
			 return sqlSessionTemplate.selectList("commonApproval.getCateApprovalLine",_pMap); 
		}

		public List<Map<String,String>>   getMultiPassLine(Map<String,String>  _pMap) { 
			 return sqlSessionTemplate.selectList("commonApproval.getMultiPassLine",_pMap); 
		}
		public List<Map<String,String>>   getMultiPassLine_v2(Map<String,Object>  _pMap) { 
			 return sqlSessionTemplate.selectList("commonApproval.getMultiPassLine_v2",_pMap); 
		}
		public List<Map<String,String>>   getCurrentPassLine_v2(Map<String,Object>  _pMap) { 
			 return sqlSessionTemplate.selectList("commonApproval.getCurrentPassLine_v2",_pMap); 
		}
		
		
		///getBuyerPxDisplayDtListPop
		public List<Map<String,String>>   approvalPrListPop(Map<String,String>  _pMap){
			return sqlSessionTemplate.selectList("commonApproval.approvalPrListPop",_pMap); 
		}
		public List<Map<String,String>>   approvalPxListPop(Map<String,String>  _pMap){
			
			_pMap.put("PO_NO", CommonUtil.onvl(_pMap.get("PO_NO"),""));
			return sqlSessionTemplate.selectList("commonApproval.approvalPxListPop",_pMap); 
		}
		public List<Map<String,String>>   approvalPrListPop_v2(Map<String,Object>  _pMap){
			return sqlSessionTemplate.selectList("commonApproval.approvalPrListPop_v2",_pMap); 
		}
		public List<Map<String,String>>   approvalPxListPop_v2(Map<String,Object>  _pMap){
			
			_pMap.put("PO_NO", CommonUtil.onvl(_pMap.get("PO_NO"),""));
			return sqlSessionTemplate.selectList("commonApproval.approvalPxListPop_v2",_pMap); 
		}
		public List<Map<String,String>>   approvalPxListPop2(Map<String,String>  _pMap){
			
			_pMap.put("PO_NO", CommonUtil.onvl(_pMap.get("PO_NO"),""));
			return sqlSessionTemplate.selectList("commonApproval.approvalPxListPop2",_pMap); 
		}
		
		/**
		 * 대상조회
		 */
		public  List<Map<String,String>>   getIcomTrgwList(Map<String,String>  _pMap) {
			return sqlSessionTemplate.selectList("commonApproval.getIcomTrgwList",_pMap); 
		}
		
		
		public List<Map<String,String>>   approvalOeListPop(Map<String,String>  _pMap) {
			return sqlSessionTemplate.selectList("commonApproval.approvalOeListPop",_pMap); 
		}
		public List<Map<String,String>>   approvalOfListPop(Map<String,String>  _pMap) {
			return sqlSessionTemplate.selectList("commonApproval.approvalOfListPop",_pMap); 
		}
		//품목별반려
		public String rejectPrListPop(Map<String,String>  formData){
			try{
			        sqlSessionTemplate.update("commonApproval.setRejectPrList", formData);  
			        //예산복원
			        sqlSessionTemplate.delete("commonApproval.updateTempBdgtUpdateRejectList", formData);  
			        String buyer = formData.get("st_buyer").toString();
					// 코웨이일경우
					String p060000036 = CommonUtil.getSpecialCheckReturn(buyer, "P06-0000036", "COL03_DATA"); // 권한특수로직
					if ("COWAY".equals(p060000036)) {
						//예산복원
						sqlSessionTemplate.update("commonApproval.updateTempBdgtUpdateCowayRejectList", formData);
					}
			}catch(Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("품목변반려 실패하였습니다.");
			}
			return null;
			 
		}
		public String rejectPrListPop_v2(Map<String,String>  formData){
			Map<String,String> _map = null;
			try{
				String query = CommonUtil.nvl(formData.get("st_query"),"");
				
				String str[] = query.split("@@",-1);
				
				_map = new HashMap<String, String>();
				
				_map.put("st_buyer", 			str[0]);
				_map.put("st_pr_no", 			str[1]);
				_map.put("st_pr_seq", 			str[2]);
				_map.put("st_prrecv_flag",		str[3]);
				_map.put("st_return_reason",	str[4]);
				sqlSessionTemplate.update("commonApproval.setRejectPrList", _map);  
			    //예산복원
		        sqlSessionTemplate.delete("commonApproval.updateTempBdgtUpdateRejectList", _map);  
			}catch(Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("품목반려 실패하였습니다.");
			}
			return null;
			 
		}
		
		public String rejectNgNsListPop_v2(Map<String,String>  formData){
			Map<String,String> _map = null;
			try{
				String query = CommonUtil.nvl(formData.get("st_query"),"");
				String check_str[]  = CommonUtil.StrToArray(query , "##");
				
				for(int i=0 ; i < check_str.length; i++){
					String str[] = check_str[i].split("@@",-1);
					
					_map = new HashMap<String, String>();
					
					_map.put("st_buyer", 			str[0]);
					_map.put("st_quotation_no", 	str[1]);
					_map.put("st_quotation_seq", 	str[2]);
					_map.put("st_recv_flag",		str[3]);
					_map.put("st_return_reason",	str[4]);
					sqlSessionTemplate.update("commonApproval.setRejectNgNsList_v2", _map);  
				}
			}catch(Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("품목반려 실패하였습니다.");
			}
			return null;
			 
		}
		
		public List<Map<String,String>> buyerCauNewPassRecvList(Map<String,String>  _pMap) {
			return sqlSessionTemplate.selectList("commonApproval.buyerCauNewPassRecvList",_pMap);
		}
		public List<Map<String,String>> buyerCauNewPassRecvExcelList(Map<String,String>  _pMap) {
			return sqlSessionTemplate.selectList("commonApproval.buyerCauNewPassRecvExcelList",_pMap);
		}
		public List<Map<String,String>> getBuyerCauCommonMyPagePopPrList(Map<String,Object> param) {
			return sqlSessionTemplate.selectList("commonApproval.getBuyerCauCommonMyPagePopPrList", param);
		}
		public Map<String,Object>  getBuyerCauCommonMyPagePop(Map<String,String>  _pMap) {
			 
			 Map<String,Object> _map = new HashMap<String,Object>();
			 String PASS_TP = _pMap.get("PASS_TP").toString();
			 String pr_docu_no = null;
			 String px_docu_no = _pMap.get("DOCU_NO").toString();
			 
			 // 발주 GW_NO 로 주문요청 결재 GW_NO 찾기
			 pr_docu_no = sqlSessionTemplate.selectOne("commonApproval.getprDocuNo", _pMap);
			 
			 /**
			  * 상태 수정
			  */
			 if ( "2".equals(PASS_TP) ){
				 sqlSessionTemplate.update("commonApproval.modfiySetRefer1",_pMap);
			 }else{
				 sqlSessionTemplate.update("commonApproval.modfiySetRefer2",_pMap);
			 }
			 
			 _map.put("MYPAGE1", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage1",_pMap));
			 _map.put("MYPAGE2", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage2",_pMap));
			 _map.put("MYPAGE4", sqlSessionTemplate.selectList("commonApproval.getAttachFileDataBaseSelect",_pMap));
			 
			 if(!"NULL".equals(pr_docu_no)) {
				 _pMap.put("DOCU_NO", pr_docu_no);
			 }
			 _map.put("MYPAGE3", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage3",_pMap));
			 _map.put("MYPAGE2_PR", sqlSessionTemplate.selectList("commonApproval.getBuyerCommonMyPage2",_pMap));
			 _map.put("MYPAGE4_PR", sqlSessionTemplate.selectList("commonApproval.getAttachFileDataBaseSelect",_pMap));
			 _pMap.put("DOCU_NO", px_docu_no);
			 return _map;
		}
		/*저장*/
		@SuppressWarnings("unchecked")
		public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
			
			String _rtnMsg = "부분 반려 처리 되었습니다.";
			
			try{
				for(int i=0; i < gridData.size(); i++){
					formData.putAll((Map<String, String>)gridData.get(i));	
					//pr반려 처리
					sqlSessionTemplate.update("commonApproval.setRejectPrMultiList", formData);
					
					//예산 복원
					sqlSessionTemplate.update("commonApproval.updateTempBdgtUpdateRejectMultiList", formData);
					
					//pr반려 메일 발송(중앙대 결재화면 전용) 최종 1회 PR번호 기준으로 발송
					if(i == gridData.size()-1) {
						sqlSessionTemplate.update("commonApproval.insertSeqRejectMail", formData);
					}
				}
			}catch(Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("부분반려 처리 실패하였습니다.");
			}
			return _rtnMsg;
		}
	
	// 고객사 별 결재 포함 필수
	@Override
	public List<Map<String, String>> getBuyerApprovalLine(Map<String, String> _pMap) {
		return sqlSessionTemplate.selectList("commonApproval.getBuyerApprovalLine",_pMap); 
	}

	// 카탈로그 계약변경 일괄수정(엑셀다운로드)
	public List<Map<String, String>> getExcelDownCamList(Map<String, String> pMap) {
		return sqlSessionTemplate.selectList("commonApproval.getExcelDownCamList", pMap);	
	}
	
	@SuppressWarnings("unchecked")
	public String updatePassLine_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "결재경로가 수정되었습니다.";
		
		try{
			//결재라인 삭제
			sqlSessionTemplate.update("commonApproval.removeICOGPASSLN",formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(formData.get("PASS_KN").equals("1")){ //기결재자 통과
					continue;
				}
				
				if(formData.get("GUBUN").equals("R")){
					continue;
				}
				
				//결재라인 넣어주기
				sqlSessionTemplate.update("commonApproval.createICOGPASSLN_v2", formData);
			}
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				if(formData.get("PASS_KN").equals("1")){ //기결재자 통과
					continue;
				}
				
				if(formData.get("GUBUN").equals("C")){
					continue;
				}else if(formData.get("GUBUN").equals("H")){
					continue;
				}
				//결재라인 넣어주기
				sqlSessionTemplate.update("commonApproval.createICOGPASSLN_v2", formData);
			}
			//'최근 결재경로' 라는 이름으로 1개 넣어줘야함 defaultflag = 'Y' 로			
			//전부 defaultflag = 'N' 처리
			sqlSessionTemplate.update("commonApproval.updateIcomapptDefaultFlag_v2",formData);
			
			String appPath = sqlSessionTemplate.selectOne("commonApproval.getAppPath_v2",formData);
			formData.put("APP_PATH", appPath);
			formData.put("SUBJECT", "최근 결재경로");
			formData.put("defaultFlag", "Y");
			
			String exsistAppPath= sqlSessionTemplate.selectOne("commonApproval.getMyRecentIcomappt_v2",formData);
			if(!exsistAppPath.equals("N")){ //이미 최근 결재경로 존재
				formData.put("APP_PATH", exsistAppPath);
				//기존 최근결재경로 default_flag = 'Y'처리
				sqlSessionTemplate.update("commonApproval.updateIcomapptDefaultFlag_v2",formData);
				//기존 결재라인 삭제 후 insert
				sqlSessionTemplate.selectOne("commonApproval.deleteMyRecentIcomapse_v2",formData);
			}else{
				//새 결재라인 만들어주기
				sqlSessionTemplate.update("commonApproval.insertMyIcomappt_v2",formData);
			}
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//결재라인 상세 넣어주기
				boolean p110000007 = CommonUtil.getSpecialCheckReturn(formData.get("COM_CODE"), "P11-0000007");
				if(p110000007) {
					//한화는 사번만 씀.
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v3",formData);
				}else {
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v2",formData);
				}
			}
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("결재경로 수정 실패하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String updatePassLine_v3(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "결재경로가 수정되었습니다.";
		
		try{
			//'최근 결재경로' 라는 이름으로 1개 넣어줘야함 defaultflag = 'Y' 로			
			//전부 defaultflag = 'N' 처리
			sqlSessionTemplate.update("commonApproval.updateIcomapptDefaultFlag_v2",formData);
			
			String appPath = sqlSessionTemplate.selectOne("commonApproval.getAppPath_v2",formData);
			formData.put("APP_PATH", appPath);
			formData.put("SUBJECT", "최근 결재경로");
			formData.put("defaultFlag", "Y");
			
			String exsistAppPath= sqlSessionTemplate.selectOne("commonApproval.getMyRecentIcomappt_v2",formData);
			if(!exsistAppPath.equals("N")){ //이미 최근 결재경로 존재
				formData.put("APP_PATH", exsistAppPath);
				//기존 최근결재경로 default_flag = 'Y'처리
				sqlSessionTemplate.update("commonApproval.updateIcomapptDefaultFlag_v2",formData);
				//기존 결재라인 삭제 후 insert
				sqlSessionTemplate.selectOne("commonApproval.deleteMyRecentIcomapse_v2",formData);
			}else{
				//새 결재라인 만들어주기
				sqlSessionTemplate.update("commonApproval.insertMyIcomappt_v2",formData);
			}
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				//결재라인 상세 넣어주기
				boolean p110000007 = CommonUtil.getSpecialCheckReturn(formData.get("COM_CODE"), "P11-0000007");
				if(p110000007) {
					//한화는 사번만 씀.
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v3",formData);
				}else {
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v2",formData);
				}
			}
			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("결재경로 수정 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	@SuppressWarnings("unchecked")
	public String insertAppPath_v2(Map<String,String>  formData, List<Object> gridData) {
		
		String _rtnMsg = "나의 결재경로가 추가되었습니다.";
		
		try{
			String appPath = sqlSessionTemplate.selectOne("commonApproval.getAppPath_v2",formData);
			formData.put("APP_PATH", appPath);
			sqlSessionTemplate.update("commonApproval.insertMyIcomappt_v2",formData);
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				if(formData.get("GUBUN").equals("R")){
					continue;
				}
				//결재라인 상세 넣어주기
				boolean p110000007 = CommonUtil.getSpecialCheckReturn(formData.get("COM_CODE"), "P11-0000007");
				if(p110000007) {
					//한화는 사번만 씀.
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v3",formData);
				}else {
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v2",formData);
				}
			}
			
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));	
				
				if(formData.get("GUBUN").equals("C")){
					continue;
				}else if(formData.get("GUBUN").equals("H")){
					continue;
				}
				
				//결재라인 상세 넣어주기
				boolean p110000007 = CommonUtil.getSpecialCheckReturn(formData.get("COM_CODE"), "P11-0000007");
				if(p110000007) {
					//한화는 사번만 씀.
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v3",formData);
				}else {
					sqlSessionTemplate.update("commonApproval.insertMyIcomapse_v2",formData);
				}
			}
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("나의 결재경로 추가 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	@Transactional
	 public String deleteMyPassLine_v2(Map<String, String> _pMap) {
		 // 삭제
		 sqlSessionTemplate.update("commonApproval.deleteMyPassLine_v2",_pMap);
		 
		return "OK";
	 }
	
}
