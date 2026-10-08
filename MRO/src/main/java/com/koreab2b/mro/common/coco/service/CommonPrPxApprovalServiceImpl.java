package com.koreab2b.mro.common.coco.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.common.coco.dao.CommonApprovalDao;
import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderInfoAlterBeforePopDao;
import com.koreab2b.mro.master.mpso.dao.MasterMpSoBuyerOrderCreationDao;
import com.koreab2b.mro.master.mpso.dao.MasterMpSoOrderInfoAlterDao;
import com.koreab2b.mro.util.CommonUtil;

@Service("CommonPrPxApprovalService")
@Transactional
public class CommonPrPxApprovalServiceImpl implements CommonPrPxApprovalService {
	 
	private static final Logger LOGGER = LoggerFactory.getLogger(CommonPrPxApprovalServiceImpl.class);

	@Autowired
	private CommonApprovalDao commonApprovalDao;  
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;  
	@Autowired
	private MasterMpSoBuyerOrderCreationDao masterMpSoBuyerOrderCreationDao;   
	@Autowired
	private MasterMpSoOrderInfoAlterBeforePopDao masterMpSoOrderInfoAlterBeforePopDao;
	@Autowired	
	private MasterMpSoOrderInfoAlterDao masterMpSoOrderInfoAlterDao;
	

	public String approval(Map<String, String> _pMap) {
		 
		 /**  
		DOC_TYPE : 
		NG	견적의뢰
		NS	소상합의
		PA	단가승인
		PR	구매요청
		PX	구매발주
		RC	견적초기화
			
		@return 
		"9";   // 임시 저장
		"0";   // 결재상태 - 결재중
	 	"1";    // 결재상태 - 반려
		"2";   // 결재상태 - 참조진행
		"3";   // 결재상태 - 결재완료
		  */
		 try{
				 String   pass_status =  commonApprovalDao.approval(_pMap); // 결재,반려 공통
					LOGGER.debug("pass_statuspass_statuspass_status   {} ", pass_status);
				 String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
				 String KEY_1 = _pMap.get("KEY_1").toString(); // 업무의키		 
				 String DOCU_NO = _pMap.get("DOCU_NO").toString(); // 결재의키
				  
				 if ( "3".equals(pass_status)) { // 결재 완료
					 
					 
					 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
					 if ("PR".equals(DOC_TYPE)){ //구매요청
						 _pMap.put("RECV_FLAG","GA");
						 buyerMpSoOrderInfoDao.setPassPr(_pMap); // setPassPr(dbcon,buyer,(String)ht.get("KEY_1"),"GA");
					 }else  if ("PX".equals(DOC_TYPE)){ //구매대행
						 _pMap.put("RECV_FLAG","PC");
						 buyerMpSoOrderInfoDao.setPxPoOrder(_pMap); //setPxPoOrder(dbcon,ht,"PC");  
						 
						 
					 }else  if ("OF".equals(DOC_TYPE)){ //고객사 주문생성
						 masterMpSoBuyerOrderCreationDao.savePmNoAfterMasterMpSoBuyerOrderCreationList(_pMap , null);  
					 }else  if ("OE".equals(DOC_TYPE)){ //주문정보수정
						 LOGGER.debug(" 주문정보수정 ");
						 
						 Map<String,String>  formData = new HashMap<String,String>();
						 Map<String,String>  formDtlData = null;
						 _pMap.put("DOCU_TYPE",DOC_TYPE);
						 List<Map<String, String>> list =  masterMpSoOrderInfoAlterBeforePopDao.getApprovalTargetOeList( _pMap ) ;
						 List<Object> gridData  = new ArrayList<Object>();
						 String MASTER_HIST_RSN_CD = "";
						 String RS_FLAG = "";
						 String C002 = "N";
						 String C003 = "N";
						 String C004 = "N";
						 String C005 = "N";
						 for (int i=0; i<list.size(); i++){
							 list = CommonUtil.getListNvl( list );
							 formDtlData = list.get(i);
							 if (i==0){
								 formData.put("st_buyer", formDtlData.get("BUYER"));
								 formData.put("budgetFlag", formDtlData.get("BUDGET_FLAG"));
								 
								 RS_FLAG = formDtlData.get("RS_FLAG");
								 if ("N".equals(RS_FLAG)){
									 formData.put("st_orderFlag", "before");
								 }else{
									 formData.put("st_orderFlag", "after");
								 }
								
								 
								 MASTER_HIST_RSN_CD = formDtlData.get("MASTER_HIST_RSN_CD"); // 전체
								 if (MASTER_HIST_RSN_CD.indexOf("C002") != -1){
									 C002 = "Y";// 거래유형변경
								 }
								 if (MASTER_HIST_RSN_CD.indexOf("C003") != -1){
									 C003 = "Y";// 협력사변경
								 }
								 if (MASTER_HIST_RSN_CD.indexOf("C004") != -1){
									 C004 = "Y";// 단가변경
								 }
								 if (MASTER_HIST_RSN_CD.indexOf("C005") != -1){
									 C005 = "Y";// 수량변경
								 }
								 
								 formData.put("st_saveFlag", "N/"+C002+"/"+C003+"/"+C004+"/"+C005+"/N/N/N/N/N"); // 전체
								 formData.put("st_reason", formDtlData.get("HIST_RSN_MEMO"));
								 formData.put("st_saveFlag_code", formDtlData.get("MASTER_HIST_RSN_CD"));
								 formData.put("userid", _pMap.get("USER_ID"));
								 
								 
							        
							        
							 }
							 
							 
							 formDtlData.put("st_po_change_user_id", formDtlData.get("PO_CHANGE_USER_ID")); 
							 formDtlData.put("REASON10", formDtlData.get("HIST_RSN_CD"));  
							 LOGGER.debug("approval  formDtlData  {} ",formDtlData); 
							 gridData.add(formDtlData);
						 }
						 
						 LOGGER.debug("approval  formData  {} ",formData); 
						 masterMpSoOrderInfoAlterBeforePopDao.saveOrderChangeCombineLogic(  formData,  gridData  , "Y") ;
						 
						 _pMap.put("PASS_STATUS",pass_status);
						 _pMap.put("DOCU_TYPE",DOC_TYPE);
						 masterMpSoOrderInfoAlterBeforePopDao.modify_ICOMPODT_DOCU_PASSSTATUS( _pMap ) ;
						 
						 
						 
						 
						 
		
						 
					 }else  if ("OEM".equals(DOC_TYPE)){ //주문정보수정 일괄 단가변경만존재
						 LOGGER.debug(" 주문정보일괄수정 ");
						 
						 Map<String,String>  formData = new HashMap<String,String>();
						 Map<String,String>  formDtlData = null;
						 _pMap.put("DOCU_TYPE",DOC_TYPE);
						 List<Map<String, String>> list =  masterMpSoOrderInfoAlterBeforePopDao.getApprovalTargetOeList( _pMap ) ;

						 String MASTER_HIST_RSN_CD = "";
						 String RS_FLAG = "";
						 String C002 = "N";
						 String C003 = "N";
						 String C004 = "N";
						 String C005 = "N";
						 for (int i=0; i<list.size(); i++){
							 List<Object> gridData  = new ArrayList<Object>();
							 list = CommonUtil.getListNvl( list );
							 formDtlData = list.get(i);
							 if (i==0){
								 formData.put("st_buyer", formDtlData.get("BUYER"));
								 formData.put("budgetFlag", formDtlData.get("BUDGET_FLAG"));
								 /*
								 RS_FLAG = formDtlData.get("RS_FLAG");
								 if ("N".equals(RS_FLAG)){
									 formData.put("st_orderFlag", "before");
								 }else{
									 formData.put("st_orderFlag", "after");
								 }
								*/
								 
								 MASTER_HIST_RSN_CD = formDtlData.get("MASTER_HIST_RSN_CD"); // 전체
 
								 if (MASTER_HIST_RSN_CD.indexOf("C004") != -1){
									 C004 = "Y";// 단가변경
								 } 
								 
								 formData.put("st_saveFlag", "N/"+C002+"/"+C003+"/"+C004+"/"+C005+"/N/N/N/N/N"); // 전체
								 formData.put("st_reason", formDtlData.get("HIST_RSN_MEMO"));
								 formData.put("st_saveFlag_code", formDtlData.get("MASTER_HIST_RSN_CD"));
								 formData.put("userid", _pMap.get("USER_ID"));   
								 
							 }
							 
							 
							 formDtlData.put("st_po_change_user_id", formDtlData.get("PO_CHANGE_USER_ID")); 
							 formDtlData.put("REASON10", formDtlData.get("HIST_RSN_CD"));  
							 //formDtlData.put("RS_FLAG", formData.get("st_orderFlag"));  
							 formDtlData.put("USER_ID", formDtlData.get("PROC_USER_ID"));   
							 
							 LOGGER.debug("approval  formDtlData  {} ",formDtlData); 
							 gridData.add(formDtlData);
							 
							 LOGGER.debug("approval  formData  {} ",formData); 
							 masterMpSoOrderInfoAlterBeforePopDao.saveOrderChangeCombineLogic(  formData,  gridData  , "Y") ;
							 							 
							 masterMpSoOrderInfoAlterDao.delMasterMpSoOrderInfoAlterMultList(   formData,  gridData ) ;
							 
							 
						 }
						 
						 _pMap.put("PASS_STATUS",pass_status);
						 _pMap.put("DOCU_TYPE",DOC_TYPE);
						 masterMpSoOrderInfoAlterBeforePopDao.modify_ICOMPODT_DOCU_PASSSTATUS( _pMap ) ;
						  					 
					 }
						
					 
				 }else if ("1".equals(pass_status)){ // 반려 <- 결재취소
					 ///kr/customer/common/popup/pop_pass/buyer_common_pass_pass_dopass.jsp
					 if ("PR".equals(DOC_TYPE)){ //구매요청
						 _pMap.put("RECV_FLAG","GR");
						 buyerMpSoOrderInfoDao.setPassPr(_pMap); // setPassPr(dbcon,buyer,(String)ht.get("KEY_1"),"GR");
						 buyerMpSoOrderInfoDao.getTempBdgtUpdateApprovalReturn(_pMap); //getTempBdgtUpdateApprovalReturn
					 }else  if ("PX".equals(DOC_TYPE)){ //구매대행
						 _pMap.put("RECV_FLAG","PR");
						 buyerMpSoOrderInfoDao.setPxPoOrder(_pMap); //setPxPoOrder(dbcon,ht,"PR");
						 buyerMpSoOrderInfoDao.getTempBdgtUpdateApprovalReturn(_pMap);  //getTempBdgtUpdateApprovalReturn
					 }else  if ("OF".equals(DOC_TYPE)){ //고객사 주문생성
						 LOGGER.debug(" 고객사 주문생성 ");
					 }else  if ("OE".equals(DOC_TYPE) || "OEM".equals(DOC_TYPE)){ //주문정보수정 , 일괄
						 LOGGER.debug(" 주문정보수정 ");
						 
						 _pMap.put("PASS_STATUS",pass_status);
						 _pMap.put("DOCU_TYPE",DOC_TYPE);
						 masterMpSoOrderInfoAlterBeforePopDao.modify_ICOMPODT_DOCU_PASSSTATUS( _pMap ) ;
					 }
							
						
				 }
		 }catch(Exception e){
	  
			throw new RuntimeException("결재 처리에 실패하였습니다.");
		 }
		 return "OK";
	 }
	

	public String cancel(Map<String, String> _pMap) { 
		
		String   status =  "";
		try{
			
			status = commonApprovalDao.cancel(_pMap); // 상신 취소 공통
			 if ("OK".equals(status)){
				 
				 String DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입
				 String KEY_1 = _pMap.get("KEY_1").toString(); // 업무의키		 
				 String DOCU_NO = _pMap.get("DOCU_NO").toString(); // 결재의키 
				 
				 if("PX".equals(DOC_TYPE)){
					 _pMap.put("RECV_FLAG","PR");
					 buyerMpSoOrderInfoDao.setPxPoOrder(_pMap); //setPxPoOrder(dbcon,ht,"PR");		
					 buyerMpSoOrderInfoDao.getTempBdgtUpdateApprovalReturn(_pMap);  //getTempBdgtUpdateApprovalReturn
				 }
	 
				 if ("OF".equals(DOC_TYPE)){ //고객사 주문생성
					 LOGGER.debug(" 고객사 주문생성 ");
				 }else  if ("OE".equals(DOC_TYPE) || "OEM".equals(DOC_TYPE)){ //주문정보수정 , 일괄정보수정
					 LOGGER.debug(" 주문정보수정 ");
					 
					 _pMap.put("PASS_STATUS","4");  //결재상태(0:진행중,1:반려,2:참조진행중,3:결재완료,4:상신취소)
					 _pMap.put("DOCU_TYPE",DOC_TYPE);
					 masterMpSoOrderInfoAlterBeforePopDao.modify_ICOMPODT_DOCU_PASSSTATUS( _pMap ) ;
				 }else{
				 ///kr/customer/common/popup/pop_pass/buyer_common_pass_change.jsp
				 status = buyerMpSoOrderInfoDao.bizCancel(_pMap); // 상신 취소 후처리 updatePrnoRecvFlag
				 }
			 }
		 }catch(Exception e){
			 
			 LOGGER.debug("상신 취소 처리에 실패하였습니다.");
				throw new RuntimeException("상신 취소 처리에 실패하였습니다.");
		 }
		 return status;
	 }

	
	public String request(Map<String, String> _pMap) {
		 /** 
			업무처리후 필요한값을 _pMap 에 넣어 호출
		  */
		 String DOC_TYPE = "";
		 String DOCU_NO = "";
		try{
				 DOC_TYPE = _pMap.get("DOC_TYPE").toString(); // 타입 
				 String TEMP = "";
				 String TEMP_ARRAY[] = null;
				 String BIZ_DOCU_NO = "";
				 String KEY_2 = "";
				if ("OF".equals(DOC_TYPE)){ //고객사 주문생성
					TEMP = masterMpSoBuyerOrderCreationDao.getPmNoMasterMpSoBuyerOrderCreationList(_pMap , null);   
					 TEMP_ARRAY = TEMP.split("@@");
					 if (TEMP_ARRAY != null && TEMP_ARRAY.length == 2){
						 BIZ_DOCU_NO =  TEMP_ARRAY[0];
						 KEY_2 =  TEMP_ARRAY[1];
					 }
					 _pMap.put("KEY_2", KEY_2); // 업무에서 만든 키		
				 }else if ("OEM".equals(DOC_TYPE)){ //주문 정보수정 (일괄)
					 
					 LOGGER.debug("주문 정보수정 (일괄)");
					 LOGGER.debug("주문 정보수정 (일괄)"+_pMap.toString());
					 LOGGER.debug("주문 정보수정 (일괄)");
					 
					 masterMpSoOrderInfoAlterDao.delMasterMpSoOrderInfoAlterMultList2(   _pMap ) ;
					 BIZ_DOCU_NO =  _pMap.get("BIZ_DOCU_NO").toString(); // 타입 
				 }else{
					 BIZ_DOCU_NO =  _pMap.get("BIZ_DOCU_NO").toString(); // 타입 
				 }
				
				_pMap.put("BIZ_DOCU_NO", BIZ_DOCU_NO); // 업무에서 만든 키		
				DOCU_NO =  commonApprovalDao.request(_pMap); // 상신  공통 <- 구현필요  
				
			 }catch(Exception e){
				 
				 LOGGER.debug("상신 처리에 실패하였습니다.");
					throw new RuntimeException("상신 처리에 실패하였습니다.");
			 } 
		return DOCU_NO;
	 }
	
	/**
	 * 임시용 PR - PX 는 사용
	 */ 
	public String request_temp(Map<String, String> _pMap) {
		 /**
		  * 견적의뢰
			소상합의
			단가승인
			주문요청
			구매발주
			--> 각업무별 다른 파일로  상신 해당업무구현 후
			아래의 공통함수 반드시 호출필요
		  */
		 return commonApprovalDao.request_temp(_pMap); // 상신  공통 <- 구현필요
	 } 
	 
}
