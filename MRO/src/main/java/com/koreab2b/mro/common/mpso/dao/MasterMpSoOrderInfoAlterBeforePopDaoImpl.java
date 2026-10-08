package com.koreab2b.mro.common.mpso.dao;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.buyer.mpso.dao.BuyerMpSoOrderInfoDao;
import com.koreab2b.mro.util.CommonUtil;

@Repository("masterMpSoOrderInfoAlterBeforePopDao")
@Transactional
public class MasterMpSoOrderInfoAlterBeforePopDaoImpl implements MasterMpSoOrderInfoAlterBeforePopDao {

	private static final Logger LOGGER = LoggerFactory.getLogger(MasterMpSoOrderInfoAlterBeforePopDaoImpl.class);
	
	@Autowired
	private BuyerMpSoOrderInfoDao buyerMpSoOrderInfoDao;
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData) {
		return sqlSessionTemplate.selectList("common.mpso.selectMasterMpSoOrderInfoAlterBeforePopList", formData);
	}
	public String getPrCardUseCheck(Map<String,String>  formData) {
		return sqlSessionTemplate.selectOne("common.mpso.getPrCardUseCheck", formData);
	}
	public List<Map<String,String>> getSysopOrderTotalAmtMainPop(Map<String, Object>  formData) {		
		formData.put("st_status_all", CommonUtil.getStringArrary( (String) formData.get("st_status") , ","));
		formData.put("statusDel", ( formData.get("st_status_all").toString().indexOf("PO10") > -1 )? "1" : "0" ); 		
		return sqlSessionTemplate.selectList("common.mpso.getSysopOrderTotalAmtMainPop", formData);
	}	
	public List<Map<String,String>> getSysopOrderTotalBuyerAmtMainPop(Map<String, Object>  formData) {	
		formData.put("st_buyer_code", CommonUtil.getStringArrary( (String) formData.get("st_buyer_code") , "@"));
		formData.put("st_status_all", CommonUtil.getStringArrary( (String) formData.get("st_status") , ","));
		formData.put("statusDel", ( formData.get("st_status_all").toString().indexOf("PO10") > -1 )? "1" : "0" ); 		
		return sqlSessionTemplate.selectList("common.mpso.getSysopOrderTotalBuyerAmtMainPop", formData);
	}	
	public List<Map<String,String>> getSysopOrderChangePoBeforeHDPop(Map<String,String>  formData) {
		return sqlSessionTemplate.selectList("common.mpso.getSysopOrderChangePoBeforeHDPop", formData);
	}
	public List<Map<String,String>> getSysopOrderChangePoBeforeDTPop(Map<String,Object>  formData) {
		return sqlSessionTemplate.selectList("common.mpso.getSysopOrderChangePoBeforeDTPop", formData);
	}
	public List<Map<String,String>> getSysopOrderChangePoBeforeDTPop_v2(Map<String,Object>  formData) {
		return sqlSessionTemplate.selectList("common.mpso.getSysopOrderChangePoBeforeDTPop_v2", formData);
	}
	public List<Map<String,String>> getSysopOrderChangePoBeforeDivisionDTPop(Map<String,Object>  formData)  {
		return sqlSessionTemplate.selectList("common.mpso.getSysopOrderChangePoBeforeDivisionDTPop", formData);
	}
	public List<Map<String,String>> getUnitMeasureInfo(Map<String,String>  formData) {
		return sqlSessionTemplate.selectList("common.mpso.getUnitMeasureInfo", formData);
	}
	public List<Map<String,String>> getHubCode(Map<String,String>  formData) {
		return sqlSessionTemplate.selectList("common.mpso.getHubCode", formData);
	}
	 
	
	/**
	 * 주문정보수정 통합처리 로직 
	 * 거래유형 공급사 단가 수량 결재를 위하여 임시저장
	 */ 
	public String saveOrderChangeCombineLogic(Map<String,String>  formData, List<Object> gridData)  { 
		return saveOrderChangeCombineLogic(  formData,  gridData  , "N") ;
	}
	
	
	
	/**
	 * 주문정보수정 통합처리 로직 
	 * 거래유형 공급사 단가 수량 결재를 위하여 임시저장 
	 * approvlYn 결재승인여부 Y 결재승인 N 일반적
	 * 
	 * C010 수량분할은 없습니다. 2014.08.06 김윤호차장님
	 */
	@SuppressWarnings({ "unchecked", "null" }) 
	public String saveOrderChangeCombineLogic(Map<String,String>  formData, List<Object> gridData ,  String approvlYn)  { 
		String _rtnMsg = "저장완료.";
		
		String buyer = "";
		String budgetFlag = ""; // 예산사용여부
		String orderFlag = ""; // 전후구분
		//String bizFlag = "";// 로직구분 거래유형변경, 협력사변경, 단가변경, 수량변경, 발주삭제, 발주초기화
		String st_saveFlag = "";
		String HIST_ID = 	"";
		
		String Po_no = "";
		String C001 =  ""; 
		String C002 =  ""; 
		String C003 =  ""; 
		String C004 =  ""; 
		String C005 =  ""; 
		String C006 =  ""; 
		String C007 =  ""; 
		String C008 =  ""; 
		String C009 =  ""; 
		String C010 =  ""; 
		String bizTitle = "저장"; 
		
		String st_save_multi = "";
		
		String tm_no = "";
		String reason10 = "";
		String reason10_array_deatil[] = null;
		String reason10_array_header[] = null;
		String CA_FLAG = "";
		
		String F_PO_MODIFY_CHK_RETURN = "";
		
		Map<String, String> pMap = new HashMap<String, String>();
		try{ 
			  
				LOGGER.debug("saveOrderChangeCombineLogic approvlYn  {} ",approvlYn);
				LOGGER.debug("saveOrderChangeCombineLogic 일반저장일반저장일반저장일반저장 ");
				if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
					// 거래유형 , 공급사, 단가, 수량 변경시에만
					LOGGER.debug("saveOrderChangeCombineLogic 결재승인으로 들어옴 ");
					/*
					// 임시저장한 테이블에서 가지고 온다
					buyer = formData.get("st_buyer");
					budgetFlag = formData.get("budgetFlag"); // 예산사용여부
					orderFlag = formData.get("st_orderFlag"); // 전후구분
					//bizFlag = formData.get("bizFlag"); // 로직구분 거래유형변경, 협력사변경, 단가변경, 수량변경, 발주삭제, 발주초기화
					st_saveFlag = formData.get("st_saveFlag"); 
					gridData = null; // 임시저장한 테이블에서 가지고 온다
					// 임시저장한 테이블에서 가지고 온다
					
					//REASON10
					// formData.get("st_saveFlag_code");
					// formData.get("st_reason");
					// formData.get("userid");
					  */
					
				}else{
					LOGGER.debug("saveOrderChangeCombineLogic 일반저장으로 들어옴 ");
			
				}

		
				
				buyer = formData.get("st_buyer");
				budgetFlag = formData.get("budgetFlag"); // 예산사용여부
				orderFlag = formData.get("st_orderFlag"); // 전후구분
				//bizFlag = formData.get("bizFlag"); // 로직구분 거래유형변경, 협력사변경, 단가변경, 수량변경, 발주삭제, 발주초기화
				st_saveFlag = formData.get("st_saveFlag"); 
				
				reason10_array_header = st_saveFlag.split("\\/");
				if (reason10_array_header != null || reason10_array_header.length == 10) { 
					C001 =  reason10_array_header[0];
					C002 =  reason10_array_header[1];
					C003 =  reason10_array_header[2];
					C004 =  reason10_array_header[3];
					C005 =  reason10_array_header[4];
					C006 =  reason10_array_header[5];
					C007 =  reason10_array_header[6];
					C008 =  reason10_array_header[7];			
					C009 =  reason10_array_header[8];			
					C010 =  reason10_array_header[9];			
				}
				
				/**
				 * 거래유형변경 또는 협력사변경 -->  신규 PO번호 채번 
				 * 모든저장을 알아내서 한건이라도 변경이 있으면 신규 PO 번호채번
				 */			 				
				/**
				 * 거래유형변경 결재품의 없애기로 하였다.
				 * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
				 * 2014.11.13
				 */
				if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
						//   협력사변경 -->  신규 PO번호 채번 
						if ("Y".equals(C003) ) {
							Po_no = buyerMpSoOrderInfoDao.getOrderNo(buyer,"PO"); // PO -- approvlYn Y
							LOGGER.debug("saveOrderChangeCombineLogic 협력사변경 -->  신규 PO번호 채번       Po_no {} ",Po_no);			
						}  
				}else{
					if ("Y".equals(C003) || "Y".equals(C004) || "Y".equals(C005)){ // 임시저장 --  협력사변경 , 수량 , 단가 변경은 결재를 타므로
						tm_no = buyerMpSoOrderInfoDao.getOrderNo("KRKORE0001","TM"); // TM
						LOGGER.debug("saveOrderChangeCombineLogic 결재로인한 임시저장 -->  신규 TM번호 채번       tm_no {} ",tm_no);			
					}
				}
			 
					
				if (st_saveFlag != null) {
					

				HIST_ID = 	sqlSessionTemplate.selectOne("common.mpso.getGlobalUniqueKey", formData);
				LOGGER.debug("saveOrderChangeCombineLogic gridData {} ",gridData); 
				/*
				 * 반복 시작
				 */ 
				for(int i=0; i < gridData.size(); i++){ // for start
					
					formData.putAll((Map<String, String>)gridData.get(i)); 
					
					st_save_multi = formData.get("st_save_multi");
					LOGGER.debug(i + "saveOrderChangeCombineLogic st_save_multi {} ",st_save_multi); 
					LOGGER.debug(i + "saveOrderChangeCombineLogic formData-------------------------------- {} ",formData); 
					LOGGER.debug(i + "saveOrderChangeCombineLogic RS_FLAG {} ",formData.get("RS_FLAG")); 

					orderFlag = sqlSessionTemplate.selectOne("common.mpso.getOrderFlag", formData);
					
					if ("Y".equals(st_save_multi)){ // 일괄업로드 일 경우 PO가 여러개 들어오므로 RS_FLAG 의 전 후 를 이용한다.
				 
						String RS_FLAG = formData.get("RS_FLAG");
//						if ("전".equals(RS_FLAG) || "before".equals(RS_FLAG) || "N".equals(RS_FLAG)){  // RS_FLAG	        	VARCHAR2(1)	수주접수 구분 N:전,Y:후
//							orderFlag = "before";
//						}else{
//							orderFlag = "after";
//						}
						LOGGER.debug("saveOrderChangeCombineLogic st_save_multi = Y RS_FLAGRS_FLAGRS_FLAGRS_FLAGRS_FLAG {} ",orderFlag);
					}else{
						if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
							String RS_FLAG = formData.get("RS_FLAG");
//							if ("전".equals(RS_FLAG) || "before".equals(RS_FLAG) || "N".equals(RS_FLAG)){ // RS_FLAG	        	VARCHAR2(1)	수주접수 구분 N:전,Y:후
//								orderFlag = "before";
//							}else{
//								orderFlag = "after";
//							}

							LOGGER.debug("saveOrderChangeCombineLogic approvlYn = Y RS_FLAGRS_FLAGRS_FLAGRS_FLAGRS_FLAG {} ",orderFlag);
						}
					}
					LOGGER.debug(i + "saveOrderChangeCombineLogic orderFlag {} ",orderFlag); 
					LOGGER.debug(i + "saveOrderChangeCombineLogic formData {} ",formData); 
					
					
					reason10 = formData.get("REASON10"); //REASON10
					reason10_array_deatil = reason10.split("\\/");
					if (reason10_array_deatil != null || reason10_array_deatil.length == 10) {
						
						C001 =  reason10_array_deatil[0];
						C002 =  reason10_array_deatil[1];
						C003 =  reason10_array_deatil[2];
						C004 =  reason10_array_deatil[3];
						C005 =  reason10_array_deatil[4];
						C006 =  reason10_array_deatil[5];
						C007 =  reason10_array_deatil[6];
						C008 =  reason10_array_deatil[7];
						C009 =  reason10_array_deatil[8];
						C010 =  reason10_array_deatil[9];
						
						if ("Y".equals(C006)){
							bizTitle = "발주삭제";
						}else 	if ("Y".equals(C007)){
							bizTitle = "발주초기화";
						}else 	if ("Y".equals(C008)){
							bizTitle = "발주종결";
						}  
						
						
					} else {
						throw new RuntimeException(bizTitle +" 에 실패하였습니다.");
					} 
					/**
					 * 협력사변경일 경우  거래명세서 생성여부를 체크한다.
					 *  생성이 된건에 되해서든 변경 불가. 현명환
					 */
					 	if(C003.equals("Y")||C002.equals("Y")){
					 		LOGGER.debug("saveOrderChangeCombineLogic 협력사변경이나 거래유형변경일 경우 거래생성서 유무 체크");
							String Inv_cnt = "0";
							Inv_cnt = sqlSessionTemplate.selectOne("common.mpso.setSysopOrderChangeBeforeCheckSave", formData);
							if (Inv_cnt==null) { Inv_cnt = "0"; }
							if (!"0".equals(Inv_cnt)){
								bizTitle = "거래명세서가 생성되어있어 발주정보 변경이 불가능 합니다.\n거래명세서 삭제후 진행 바랍니다. 변경";
								throw new RuntimeException(bizTitle);
							}
					 	}
						if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
							LOGGER.debug("saveOrderChangeCombineLogic 일반저장 결재승인으로 들어옴 ");
							
							C001 = "N";
							/**
							 * 거래유형변경 결재품의 없애기로 하였다.
							 * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
							 * 2014.11.13
							 */
							C002 =  "N";
							C003 =  reason10_array_deatil[2]; // 결재 후 임시테이블에서 가지고옴
							C004 =  reason10_array_deatil[3]; // 결재 후 임시테이블에서 가지고옴
							C005 =  reason10_array_deatil[4]; // 결재 후 임시테이블에서 가지고옴
							
							C006 = "N";
							C007 = "N";
							C008 = "N";
							C009 = "N";
							C010 = "N"; 
						}else{
							
							/**
							 * 거래유형변경 결재품의 없애기로 하였다.
							 * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
							 * 2014.11.13
							 */ 
							if ("Y".equals(C003) || "Y".equals(C004) || "Y".equals(C005)){ // 임시저장 -- 거래유형변경 , 협력사변경 , 수량 , 단가 변경은 결재를 타므로					
								LOGGER.debug("saveOrderChangeCombineLogic 일반저장 임시저장 결재로 들어옴 ");								
								
							
								
								if (!"".equals(tm_no)){
									formData.put("DOCU_NO", tm_no);  
									formData.put("BUDGET_FLAG", budgetFlag);  
									formData.put("HIST_RSN_CD", formData.get("REASON10"));  
									formData.put("PROC_USER_ID", formData.get("userid"));
									formData.put("PO_CHANGE_USER_ID", formData.get("st_po_change_user_id"));				
									formData.put("COMPANY", formData.get("buyer"));				
									formData.put("HIST_ID", HIST_ID);
									//외화단가 관련 변경시 해당 내용임시보관.
									formData.put("DOCU_EXP_CUR", CommonUtil.nvl(formData.get("EXP_CUR"),""));
									formData.put("DOCU_EXP_CUR_PRICE", CommonUtil.nvl(formData.get("EXP_CUR_PRICE"),""));
									formData.put("DOCU_EXP_GR_NO", CommonUtil.nvl(formData.get("EXP_GR_NO"),""));
									formData.put("DOCU_EXP_DATE_OF_SHIPMENT", CommonUtil.nvl(formData.get("EXP_DATE_OF_SHIPMENT"),""));
									if ("before".equals(orderFlag)){
										formData.put("RS_FLAG", "N");
									}else{
										formData.put("RS_FLAG", "Y");							
									}
									LOGGER.debug("saveOrderChangeCombineLogic 일반저장 임시저장 결재로 들어옴 ICOMPODT_DOCU insert ");
									sqlSessionTemplate.update("common.mpso.registerICOMPODT_DOCU", formData);									
									LOGGER.debug("saveOrderChangeCombineLogic 일반저장 임시저장 결재로 들어옴 ICOMPODT_DOCU insert ");
								}
								/**
								 * 거래유형변경 결재품의 없애기로 하였다.
								 * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
								 * 2014.11.13
								 */  
								C003 = "N";
								C004 = "N";
								C005 = "N";
							}
						}
						
						formData.put("C001", C001); // 단순항목변경
						formData.put("C002", C002); // 거래유형변경
						formData.put("C003", C003); // 협력사변경
						formData.put("C004", C004); // 단가변경
						formData.put("C005", C005); // 수량변경
						
						formData.put("C006", C006); // 발주삭제
						formData.put("C007", C007); // 발주초기화
						formData.put("C008", C008); // 발주종결
						
						formData.put("C009", C009); // 종결복원
						formData.put("C010", C010); // 수량분할
						

						
						LOGGER.debug("saveOrderChangeCombineLogic 전후구분   orderFlag {} ",orderFlag);
						LOGGER.debug("saveOrderChangeCombineLogic 단순항목변경  C001 {} ",C001);
						LOGGER.debug("saveOrderChangeCombineLogic 거래유형변경  C002 {} ",C002);
						LOGGER.debug("saveOrderChangeCombineLogic 협력사변경     C003 {} ",C003);
						LOGGER.debug("saveOrderChangeCombineLogic 단가변경        C004 {} ",C004);
						LOGGER.debug("saveOrderChangeCombineLogic 수량변경        C005 {} ",C005);
						
						LOGGER.debug("saveOrderChangeCombineLogic 발주삭제        C006 {} ",C006);
						LOGGER.debug("saveOrderChangeCombineLogic 발주초기화     C007 {} ",C007);
						LOGGER.debug("saveOrderChangeCombineLogic 발주종결        C008 {} ",C008);
						LOGGER.debug("saveOrderChangeCombineLogic 종결복원        C009 {} ",C009);
						LOGGER.debug("saveOrderChangeCombineLogic 수량분할        C010 {} ",C010);
						
						
						LOGGER.debug(i + "saveOrderChangeCombineLogic st_save_multi {} ",st_save_multi); 
						if ("Y".equals(st_save_multi)){ // 일괄업로드 일 경우 PO가 여러개 들어오므로 
							
							/*
							 *    parameter : 1. 고객사 코드
				               2. 발주번호 po_no
				               3. 변경사유코드 합
				               4. 변경사유  
				               5. 처리자 USER_ID(세션)  
				   				comments  : [운영사 > 주문정보수정]에서 주문정보 변경시, 
				                         발주종결/수량분할 시 호출되며, 
				                         처리내용은 변경이력 생성이다. 
							 */					 
			
							formData.put("HIST_RSN_CD", formData.get("st_saveFlag_code"));
							formData.put("HIST_RSN_MEMO", formData.get("st_reason"));
							formData.put("PROC_USER_ID", formData.get("userid"));
							formData.put("HIST_ID", HIST_ID);
	
							sqlSessionTemplate.update("common.mpso.call_PROC_ODRHIST_GEN", formData); 
							
						}else{
							if (i ==0) {	
								/*
								 *    parameter : 1. 고객사 코드
					               2. 발주번호 po_no
					               3. 변경사유코드 합
					               4. 변경사유  
					               5. 처리자 USER_ID(세션)  
					   				comments  : [운영사 > 주문정보수정]에서 주문정보 변경시, 
					                         발주종결/수량분할 시 호출되며, 
					                         처리내용은 변경이력 생성이다. 
								 */					 
				
								formData.put("HIST_RSN_CD", formData.get("st_saveFlag_code"));
								formData.put("HIST_RSN_MEMO", formData.get("st_reason"));
								formData.put("PROC_USER_ID", formData.get("userid"));
								formData.put("HIST_ID", HIST_ID);
		
								sqlSessionTemplate.update("common.mpso.call_PROC_ODRHIST_GEN", formData); 
								
							} 
						}
						
						if ("N".equals(C001) &&
								"N".equals(C002) &&
								"N".equals(C003) &&
								"N".equals(C004) &&
								"N".equals(C005) &&
								"N".equals(C006) &&
								"N".equals(C007) &&
								"N".equals(C008) &&
								"N".equals(C009) &&
								"N".equals(C010)
							){
							LOGGER.debug("saveOrderChangeCombineLogic 저장될게 없음 (오직 임시저장만 있는경우) 결재만 있습니다.");
						}else{ 
											  
											
											LOGGER.debug("saveOrderChangeCombineLogic 거래유형변경 또는 협력사변경        Po_no {} ",Po_no);
											
											// 발주삭제 -- 수주접수전만 체크
											//수주접수된 발주건은 발주정보수정 메인 화면에서 다시 조회 후 , 수주접수후 팝업 화면에서 발주정보를 수정하도록 한다.
											String pors_cnt = "0";
											if ("before".equals(orderFlag) && "Y".equals(C006)){
												pors_cnt = sqlSessionTemplate.selectOne("common.mpso.setSysopOrderChangeBeforeSave1", formData);
												if (pors_cnt==null) { pors_cnt = "0"; }
												if (!"0".equals(pors_cnt)){
													bizTitle = formData.get("PO_NO") + "/" + formData.get("PO_SEQ") +" 선택하신 목록은 협력사에서 이미 수주접수한 품목입니다.\n\n수주접수상태가 바뀌었으므로 팝업을 종료하신후 다시 실행하시기 바랍니다.";
													throw new RuntimeException();
												}
											}
															
											//ICOMPRDT 변경처리
											sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPRDT", formData);
											

											if("Y".equals(C002)){ // 거래유형 변경 포함 시 중복발주 생성 방지 로직 START 2019.03.12 HSJ
												formData.put("MODIFY_CHK_FLAG", "START"); // 체크로직 시작(ICOMTRXL 데이터 저장)
												F_PO_MODIFY_CHK_RETURN = sqlSessionTemplate.selectOne("common.mpso.getPoModifyChk", formData);
												
												if(("OK").equals(F_PO_MODIFY_CHK_RETURN)){ // 체크 이상 있으면 EXCEPTION 종료
												}else{
													throw new RuntimeException(F_PO_MODIFY_CHK_RETURN);
												}
											}
											
											//ICOMPODT 변경처리
											sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPODT", formData);
											
											/**
											 * 특수로직 추가. 2016-02-29
											 * 한국항공우주산업일 경우 RD_DATE 변경시 PROC_PO_MNG 를 실행한다.
											 */
											boolean p060000067 =  CommonUtil.getSpecialCheckReturn(buyer,"P06-0000067");
											
											if (true == p060000067) {
												String rdDate	= formData.get("RD_DATE");
												String rdDateOrigin	= formData.get("RD_DATE_ORIGIN");
												if ( null != rdDate && !rdDate.equals(rdDateOrigin)) {
													formData.put("COLUMN", "RD_DATE");
													sqlSessionTemplate.update("common.mpso.call_PROC_PO_MNG", formData);	
												}
											}
											
											//거래유형변경 또는 협력사변경 (채번한 PO번호로 신규생성 )
											// INSERT ICOMPODT   신규PODT 생성 
											if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
												/**
												* 거래유형변경 결재품의 없애기로 하였다.
												* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
												* 2014.11.13
												*/
												if ( "Y".equals(C003) ) {
													
													LOGGER.debug("saveOrderChangeCombineLogic INSERT ICOMPODT   신규PODT 생성 협력사변경      Po_no {} ",Po_no);
													
													formData.put("NEW_PO_NO", Po_no);  
													sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_createICOMPODT", formData);
												} 
											}else{
												/**
												* 거래유형변경 결재품의 없애기로 하였다.
												* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
												* 2014.11.13
												*/
												if ("Y".equals(C002) ) {
													// 거래유형변경  -->  신규 PO번호 채번
													
													if(i==0){ // 반복문 내에서 한 번만 실행(채번)
														Po_no = buyerMpSoOrderInfoDao.getOrderNo(buyer,"PO"); // PO -- approvlYn Y
														LOGGER.debug("saveOrderChangeCombineLogic 거래유형변경 -->  신규 PO번호 채번       Po_no {} ",Po_no);			
													}
													LOGGER.debug("saveOrderChangeCombineLogic INSERT ICOMPODT   신규PODT 생성  거래유형변경    Po_no {} ",Po_no);
													
													LOGGER.debug("F_PO_MODIFY_CHK_RETURN 결과값 : {} ", F_PO_MODIFY_CHK_RETURN);
													
													if(("OK").equals(F_PO_MODIFY_CHK_RETURN)){
														formData.put("NEW_PO_NO", Po_no);  
														sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_createICOMPODT", formData);

														formData.put("MODIFY_CHK_FLAG", "END"); // 정상 종료 시 ICOMPODT 생성 후 체크로직 해제(ICOMTRXL 데이터 삭제)
														F_PO_MODIFY_CHK_RETURN = sqlSessionTemplate.selectOne("common.mpso.getPoModifyChk", formData);
													}else{
														throw new RuntimeException(F_PO_MODIFY_CHK_RETURN);
													}
												} 
											}
											
											LOGGER.debug("saveOrderChangeCombineLogic formData  _rtnMsg {} ",formData);
											
											
											
											//발주삭제 메일
											//품의 결재 승인시
											if ("Y".equals(C006) ){ 
							   			        	 
								    	        
											} 
											
											/*
								            IF 수주접수 전 AND 변경코드 단순저장 이면
							                // 납기일 변경시 
							                ///* 41 AS-IS : 납기일변경시 메일 전송 로직 
							                // 두산중공업 특수로직  
							                // 납기일 변경 로직을 납품합의일 변경 기능으로 대체 협의 
							            
							    
											END//IF 수주접수 전 상태이면
											*/
											if ("N".equals(C008) && "N".equals(C009) && "N".equals(C010)) { // 발주종결 종결복원 수량분할 아닐경우
												LOGGER.debug("saveOrderChangeCombineLogic 전후구분   orderFlag {} ",orderFlag);
												if ("before".equals(orderFlag) && "Y".equals(C001)) { 
													
													if(buyer.equals("KRDOOD0001")){
													//  2005년 10월 14일 구매사(두산중공업 이외) 납기요청 변경시 공급사에 메일 발송 구현
														//ICOMPOIF_DOOSAN 변경처리
														sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeSave4", formData);
														
														pMap.put("MAILFORM_ID", "PO_MOD_RD_DATE_BS"); 
														pMap.put("SEND_COM_TYPE", "B"); 
														pMap.put("RECV_COM_TYPE", "S"); 
														pMap.put("SEND_COM_CODE", "KRKORE0001"); 
														pMap.put("SEND_USER_ID", "KOREAB2B"); 
														pMap.put("KEY1", formData.get("BUYER")); 
														pMap.put("KEY2", formData.get("PO_NO"));  
														pMap.put("KEY3", formData.get("PO_SEQ"));  
														pMap.put("KEY4", formData.get("RD_DATE_ORIGIN"));  // RD_DATE 납기요청일 수정안하는대?
														pMap.put("KEY5", formData.get("RD_DATE"));  			 // RD_DATE 납기요청일 수정안하는대?
														pMap.put("KEY5SEQ", "N");  
														pMap.put("KEY6", CommonUtil.formatDateNoDateGubun(new Date() , 3)  );  
														 
													}else{
													
														pMap.put("MAILFORM_ID", "PO_MOD_RDDATE_ALL_MS"); 
														pMap.put("SEND_COM_TYPE", "M"); 
														pMap.put("RECV_COM_TYPE", "S"); 
														pMap.put("SEND_COM_CODE", "KRKORE0001"); 
														pMap.put("SEND_USER_ID", "KOREAB2B"); 
														pMap.put("KEY1", formData.get("BUYER")); 
														pMap.put("KEY2", formData.get("PO_NO"));  
														pMap.put("KEY3", formData.get("PO_SEQ"));  
														pMap.put("KEY4", formData.get("RD_DATE_ORIGIN"));   // RD_DATE 납기요청일 수정안하는대?
														pMap.put("KEY5", formData.get("RD_DATE"));  			 // RD_DATE 납기요청일 수정안하는대?
														pMap.put("KEY5SEQ", "N");  
														pMap.put("KEY6", CommonUtil.formatDateNoDateGubun(new Date() , 3)  );  
														
													}
													
													//LOGGER.debug("saveOrderChangeCombineLogic mailSend       pMap {} ",pMap);
													//MailSmsUtil.mailSend(pMap); // 메일 전송
												}
											}
											
											/*
											 *  IF 수주접수 후 상태이면
											 */
											if ("N".equals(C008) && "N".equals(C009) && "N".equals(C010)) { // 발주종결 종결복원 수량분할 아닐경우
												if ("after".equals(orderFlag)) {
													
													//UPDATE ICOMIVDT   변경처리
													sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMIVDT", formData);					
													
													//UPDATE ICOMIVHD   변경처리
													sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMIVHD2", formData);
													
													//UPDATE ICOMPORS   변경처리
													sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPORS", formData);
													
													
													// 단가변경
													if ("Y".equals(C004)) {
														//UPDATE WMSIVDT   변경처리
														sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyWMSIVDT", formData);
														//UPDATE ICOMGRDT   변경처리
														sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMGRDT", formData);
													}
												}
											}
											
											
											
											
											CA_FLAG = CommonUtil.nvl( formData.get("CA_FLAG") , formData.get("REASON6") ); // 카탈로그 변경(발주변경시) 
											LOGGER.debug("saveOrderChangeCombineLogic CA_FLAG       CA_FLAG {} ",CA_FLAG);
											if ("Y".equals(C003) || "Y".equals(C004)) { // 단가변경 또는 협력사변경 일 경우에만 카탈로그 변경 가능
												if ( "Y".equals(CA_FLAG)  || "1".equals(CA_FLAG) ) {
													sqlSessionTemplate.update("common.mpso.modifyApprovalCa_flag1", formData); // ICOMCQDT
													sqlSessionTemplate.update("common.mpso.modifyApprovalCa_flag2", formData); //ICOMCQEP
													sqlSessionTemplate.update("common.mpso.modifyApprovalCa_flag3", formData); // ICOMCQEP
													sqlSessionTemplate.update("common.mpso.modifyApprovalCa_flag4", formData); //ICOMBYIT
												} 
											}
											if ("Y".equals(C004)) { // 단가변경 변경시 외화단가 매핑되어있으면 단가 업데이트.
												if ( "Y".equals(CA_FLAG)  || "1".equals(CA_FLAG) ) {
													//외화단가 업데이트
													sqlSessionTemplate.update("common.mpso.modifyApprovalCa_flag5", formData); //KEP_CURRENCY_DT
													sqlSessionTemplate.update("common.mpso.modifyApprovalCa_flag6", formData); //KEP_CURRENCY_HIST
												} 
											}
											
											
					}
				} // for end
				
				/*
				 * 반복 끝  
				 */
				 
				
				/*
				 *  헤더 시작
				 */ 
				if (reason10_array_header != null  ) {						
						if (reason10_array_header.length == 10){
							C001 =  reason10_array_header[0];
							C002 =  reason10_array_header[1];
							C003 =  reason10_array_header[2];
							C004 =  reason10_array_header[3];
							C005 =  reason10_array_header[4];
							C006 =  reason10_array_header[5];
							C007 =  reason10_array_header[6];
							C008 =  reason10_array_header[7];
							C009 =  reason10_array_header[8];
							C010 =  reason10_array_header[9];
							
							
		 
							if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
								
								C001 = "N";
								/**
								* 거래유형변경 결재품의 없애기로 하였다.
								* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
								* 2014.11.13
								*/
								C002 =  "N";
								C003 =  reason10_array_header[2]; // 결재 후 임시테이블에서 가지고옴
								C004 =  reason10_array_header[3]; // 결재 후 임시테이블에서 가지고옴
								C005 =  reason10_array_header[4]; // 결재 후 임시테이블에서 가지고옴
								
								C006 = "N";
								C007 = "N";
								C008 = "N";
								C009 = "N";
								C010 = "N"; 
							}else{
								if ("Y".equals(C003) || "Y".equals(C004) || "Y".equals(C005)){ // 임시저장 -- 거래유형변경 , 협력사변경 , 수량 , 단가 변경은 결재를 타므로
									/**
									* 거래유형변경 결재품의 없애기로 하였다.
									* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
									* 2014.11.13
									*/
									C003 = "N";
									C004 = "N";
									C005 = "N";
								}
							}
				 
							
							formData.put("C001", C001); // 단순항목변경
							formData.put("C002", C002); // 거래유형변경
							formData.put("C003", C003); // 협력사변경
							formData.put("C004", C004); // 단가변경
							formData.put("C005", C005); // 수량변경					
							formData.put("C006", C006); // 발주삭제
							formData.put("C007", C007); // 발주초기화
							formData.put("C008", C008); // 발주종결
							formData.put("C009", C009); // 종결복원
							formData.put("C010", C010); // 수량분할
							
							
							LOGGER.debug("saveOrderChangeCombineLogic header 단순항목변경  C001 {} ",C001);
							LOGGER.debug("saveOrderChangeCombineLogic header 거래유형변경  C002 {} ",C002);
							LOGGER.debug("saveOrderChangeCombineLogic header 협력사변경     C003 {} ",C003);
							LOGGER.debug("saveOrderChangeCombineLogic header 단가변경        C004 {} ",C004);
							LOGGER.debug("saveOrderChangeCombineLogic header 수량변경        C005 {} ",C005);
							
							LOGGER.debug("saveOrderChangeCombineLogic header 발주삭제        C006 {} ",C006);
							LOGGER.debug("saveOrderChangeCombineLogic header 발주초기화     C007 {} ",C007);
							LOGGER.debug("saveOrderChangeCombineLogic header 발주종결        C008 {} ",C008);
							LOGGER.debug("saveOrderChangeCombineLogic header 종결복원        C009 {} ",C009);
							LOGGER.debug("saveOrderChangeCombineLogic header 수량분할        C010 {} ",C010);
							
							
							if ("N".equals(C001) &&
									"N".equals(C002) &&
									"N".equals(C003) &&
									"N".equals(C004) &&
									"N".equals(C005) &&
									"N".equals(C006) &&
									"N".equals(C007) &&
									"N".equals(C008) &&
									"N".equals(C009) &&
									"N".equals(C010)
								){
								LOGGER.debug("saveOrderChangeCombineLogic 저장될게 없음 (오직 임시저장만 있는경우) 결재만 있습니다.");
							}else{
												
												if ("N".equals(C008) && "N".equals(C009) && "N".equals(C010)) { // 발주종결 종결복원 수량분할 아닐경우
													
													
													LOGGER.debug("saveOrderChangeCombineLogic 전후구분   orderFlag {} ",orderFlag);
													//단순항목 저장이 아니고 수주접수 후 이면 			
													if ("after".equals(orderFlag) && !"Y".equals(C001)) {
														
														//UPDATE ICOMIVHD   변경처리
														sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMIVHD", formData);				 
													}
													
													//UPDATE ICOMPOHD   변경처리
													sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPOHD", formData);			
													
													// INSERT ICOMPOHD   신규POHD생성
													if ("Y".equals(approvlYn)){ // 일반저장 - 결재승인 - 임시테이블이 넣은 정보를 이용하여 실제 로직 처리 
														/**
														* 거래유형변경 결재품의 없애기로 하였다.
														* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
														* 2014.11.13
														*/
														if ("Y".equals(C003) ) {									
															LOGGER.debug("saveOrderChangeCombineLogic  INSERT ICOMPOHD   신규POHD생성   협력사변경   Po_no {} ",Po_no);				
															sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_createICOMPOHD", formData);
															
															
															String old_PO_NO = formData.get("PO_NO");
															//UPDATE ICOMPOHD   변경처리
															formData.put("PO_NO", Po_no);
															sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPOHD", formData);		
															
															formData.put("NEW_PO_NO",Po_no);
															formData.put("PO_NO",old_PO_NO); // PO_NO 다시 원복
															
															LOGGER.debug("saveOrderChangeCombineLogic  INSERT ICOMPOHD   신규POHD생성 협력사변경     NEW_PO_NO {} ",formData.get("NEW_PO_NO"));				
															LOGGER.debug("saveOrderChangeCombineLogic  INSERT ICOMPOHD   신규POHD생성 협력사변경      PO_NO {} ",formData.get("PO_NO"));				
														} 
													} 	else{
														/**
														* 거래유형변경 결재품의 없애기로 하였다.
														* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
														* 2014.11.13
														*/
														if ("Y".equals(C002)  ) {									
															LOGGER.debug("saveOrderChangeCombineLogic  INSERT ICOMPOHD   신규POHD생성   거래유형변경   Po_no {} ",Po_no);				
															sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_createICOMPOHD", formData);
															
															
															String old_PO_NO = formData.get("PO_NO");
															//UPDATE ICOMPOHD   변경처리
															formData.put("PO_NO", Po_no);
															sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPOHD", formData);		
															
															formData.put("NEW_PO_NO",Po_no);
															formData.put("PO_NO",old_PO_NO); // PO_NO 다시 원복
															
															LOGGER.debug("saveOrderChangeCombineLogic  INSERT ICOMPOHD   신규POHD생성    거래유형변경  NEW_PO_NO {} ",formData.get("NEW_PO_NO"));				
															LOGGER.debug("saveOrderChangeCombineLogic  INSERT ICOMPOHD   신규POHD생성   거래유형변경   PO_NO {} ",formData.get("PO_NO"));				
														} 
													}
												}
												
												//UPDATE ICOMPRHD   변경처리
												sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMPRHD", formData);				
												
												LOGGER.debug("saveOrderChangeCombineLogic 전후구분   orderFlag {} ",orderFlag);
												LOGGER.debug("saveOrderChangeCombineLogic 예산반영  budgetFlag {} ",budgetFlag);
												/*
												 *       IF  수주접수 후, 변경코드: 발주삭제 AND 예산을 사용하는 회사이면 
									        			OR 수주접수 전, 변경코드: 단순저장 
									        			
									        			예산반영 로직 
												 */
												if ("N".equals(C008) && "N".equals(C009) && "N".equals(C010)) { // 발주종결 종결복원 수량분할 아닐경우
														if (( "Y".equals(C006) && "Y".equals(budgetFlag)) || ("before".equals(orderFlag) &&  "Y".equals(C001))) {
														
															//UPDATE ICOMBDGT   변경처리
															sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_modifyICOMBDGT", formData);	
															
															/*
															 *  IF 고객사가 코웨이 이면
															 */ 
															//SLOGIC-BEGIN(P06-0000036)
															String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL03_DATA"); // 권한특수로직
															LOGGER.debug("saveOrderChangeCombineLogic 고객사가 코웨이  p060000036 {} ",p060000036);
															if ("COWAY".equals(p060000036)){
																sqlSessionTemplate.update("common.mpso.saveOrderChangeCombineLogic_createCOWAY_BUDGET_ACTUAL", formData);		
															}
															//SLOGIC-END
															
															sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete5BudgetUpdate2", formData);
													} 
												}
											}
						}
					}
				} 
	    	        
	    	          
				 
				 
		        Map<String,String>  _pMap2_old = new HashMap<String,String>();
		        Map<String,String>  _pMap2_new = new HashMap<String,String>();
		        boolean mail_old = false;
		        boolean mail_new = false;
		        
		        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  approvlYn {} ",approvlYn); 
	        	_pMap2_old.put("BUYER",formData.get("BUYER"));
	        	_pMap2_new.put("BUYER",formData.get("BUYER"));
	        	
		        if ("Y".equals(approvlYn)){
			        /**
			        * 거래유형변경 결재품의 없애기로 하였다.
			        * 협력사변경 , 수량 , 단가 변경 결재품의 한다.
			        * 2014.11.13
			        */
			    	if ("Y".equals(C003) ) {		
			    		_pMap2_new.put("PO_NO", Po_no);
			    		_pMap2_old.put("PO_NO", formData.get("PO_NO"));
			    		mail_new = true;
				        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  111111111111111 {} ",approvlYn); 
			    	}else{
			    		_pMap2_old.put("PO_NO", formData.get("PO_NO"));
			    		mail_new = false;
				        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  2222222222222222 {} ",approvlYn); 
			    	}
			    	_pMap2_old.put("CODE", HIST_ID);
			    	_pMap2_new.put("CODE","PO_NEW");
			    	_pMap2_old.put("USER_ID",formData.get("userid"));
			    	_pMap2_new.put("USER_ID",formData.get("userid"));
			    	mail_old = true;
		        }else{
		        	/**
		        	* 거래유형변경 결재품의 없애기로 하였다.
		        	* 협력사변경 , 수량 , 단가 변경 결재품의 한다.
		        	* 2014.11.13
		        	*/
		        	if ("Y".equals(C002) ) {		
		        		_pMap2_new.put("PO_NO", Po_no); 
		        		_pMap2_new.put("CODE","PO_NEW");
		        		_pMap2_new.put("USER_ID",formData.get("userid"));	
		        		
				        _pMap2_old.put("PO_NO", formData.get("PO_NO"));
				        _pMap2_old.put("CODE", HIST_ID);
				        _pMap2_old.put("USER_ID",formData.get("userid"));	
				        
		        		mail_new = true;
		        		mail_old = true;
				        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  111111111111111 {} ",approvlYn); 
			    	}
		        	
		        	if ( "Y".equals(C006) ||  "Y".equals(C007)  ) {		
				        _pMap2_old.put("PO_NO", formData.get("PO_NO"));
				        _pMap2_old.put("CODE", HIST_ID);
				        _pMap2_old.put("USER_ID",formData.get("userid"));		
				        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  333333333333333 {} ",approvlYn); 
				        mail_old = true;
				        mail_new = false;
		        	}
		        }
		        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  formData {} ",formData);
		        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  mail_new {} ",mail_new);
		        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  _pMap2_new {} ",_pMap2_new);
		        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  mail_old {} ",mail_old);
		        LOGGER.debug("saveOrderChangeCombineLogic    call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO  _pMap2_old {} ",_pMap2_old);
		        if (mail_new == true){
		        	buyerMpSoOrderInfoDao.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap2_new); // 메일 발송 패키지
		        }
		        if (mail_old == true){
		        	buyerMpSoOrderInfoDao.call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(_pMap2_old); // 메일 발송 패키지
		        }
 
 
			/*
			 *  헤더 끝
			 */
			 

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			if("".equals(F_PO_MODIFY_CHK_RETURN) || "OK".equals(F_PO_MODIFY_CHK_RETURN)){
				throw new RuntimeException(bizTitle +" 에 실패하였습니다.");
			}else{
				throw new RuntimeException(F_PO_MODIFY_CHK_RETURN);
			}
		}
		
		
		
		if (tm_no == null || "".equals(tm_no)){
			if (Po_no == null || "".equals(Po_no)){
				_rtnMsg =bizTitle +" 되었습니다.";
			}else{
				_rtnMsg = bizTitle +"성공적으로 이루어 졌습니다.\n\n변경된 품목의 새로운 발주번호는 " +Po_no +" 입니다.\n중복 납품되지 않도록 관리해주시기 바랍니다.";
			}
		}else{
			_rtnMsg = tm_no;
		}
		
		LOGGER.debug("saveOrderChangeCombineLogic END  _rtnMsg {} ",_rtnMsg);
		
		return _rtnMsg;
	}
	
	 
		/**
		 * 주문정보수정 임시 통합처리 로직 
		 */
		public String saveOrderChangeTempCombineLogic(Map<String,String>  formData, List<Object> gridData) {
			
			
			 
			return "수량분할 되었습니다.";
		}
		
	/**
	 * 주문정보수정 수량분할 통합처리 로직 
	 */
	public String saveOrderChangeDivisionCombineLogic(Map<String,String>  formData, List<Object> gridData) {
		
		
		String buyer = formData.get("st_buyer");
		String new_pr = "";
		String new_po = "";
			try{ 
				new_pr = buyerMpSoOrderInfoDao.getOrderNo(buyer,"PR"); // PO
				new_po = buyerMpSoOrderInfoDao.getOrderNo(buyer,"PO"); // PO
					/*
					 * 반복 시작
					 */ 
					for(int i=0; i < gridData.size(); i++){ // for start
						formData.putAll((Map<String, String>)gridData.get(i)); 
						
						/*
						 *    parameter : 1. 고객사 코드
			               2. 발주번호 po_no
			               3. 변경사유코드 합
			               4. 변경사유  
			               5. 처리자 USER_ID(세션)  
			   				comments  : [운영사 > 주문정보수정]에서 주문정보 변경시, 
			                         발주종결/수량분할 시 호출되며, 
			                         처리내용은 변경이력 생성이다. 
						 */					 
						formData.put("HIST_RSN_CD", "C009^");
						formData.put("HIST_RSN_MEMO", formData.get("st_reason"));
						formData.put("PROC_USER_ID", formData.get("userid"));
						sqlSessionTemplate.update("common.mpso.call_PROC_ODRHIST_GEN", formData);
						
						
					}
			} catch (Exception e){
				LOGGER.error("SQL ERROR : ", e);
				throw new RuntimeException("수량분할에 실패하였습니다.");
			}
		return "수량분할 되었습니다.";
	}
	
	public String saveSysopOrderChangeClear(Map<String,String>  formData, List<Object> gridData) { 
		String _rtnMsg = "발주초기화 완료되었습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				LOGGER.debug("saveSysopOrderChangeClear formData {} ",formData);
				
				// ICOMPRDT
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterPoInit1", formData);
				
				// ICOMPODT
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterPoInit2", formData);
				
				// ICOMPORS
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterPoInit3", formData);
				
				// ICOMIVDT
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterPoInit4", formData); 
				
				// ICOMPRHD
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterPoInit5", formData); 
				
				// ICOMPOHD
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterProcessTypeModify6", formData);
								
				
				// ICOMIVHD
				sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterPoInit6", formData);
				
				
				
				
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주초기화에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	public String saveSysopOrderChangeEnd(Map<String,String>  formData, List<Object> gridData) { 
		String _rtnMsg = "발주종결 완료되었습니다.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주종결에 실패하였습니다.");
		}
		return _rtnMsg;
	} 
	public String setSysopOrderChangeBeforeDelete(Map<String,String>  formData, List<Object> gridData) { 
		String _rtnMsg = "발주삭제 완료되었습니다.";
		String icomporsCnt = "0";
		
		String st_orderFlag = formData.get("st_orderFlag").toString();
		
		String plan_amt_flag = "";
		String buyer = "";
		
		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				
				LOGGER.debug("setSysopOrderChangeBeforeDelete formData {} ",formData);
				
				
				if (!"after".equals(st_orderFlag)){ // 발주전
					// ICOMPORS
					icomporsCnt = sqlSessionTemplate.selectOne("common.mpso.setSysopOrderChangeBeforeSave1", formData);
					if (icomporsCnt == null) icomporsCnt = "0";
				}
				
				plan_amt_flag   = 				formData.get("PLAN_AMT_FLAG").toString();
				buyer   = 				formData.get("BUYER").toString();
 
				LOGGER.debug("setSysopOrderChangeBeforeDelete icomporsCnt {} ",icomporsCnt);
				
				if ("0".equals(icomporsCnt)){
					
					// ICOMPRDT
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterDelete1", formData);					
					// ICOMPODT
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterDelete2", formData);
					// ICOMPORS
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterDelete3", formData);
					// ICOMIVDT
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterDelete4", formData);
					// ICOMIVHD
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterProcessTypeModify6", formData);
					
					// ICOMPRHD
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeAfterDelete5", formData);				
					
					// ICOMPOHD
					sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeProcessTypeModify6", formData);
					
					if ("Y".equals(plan_amt_flag)){
							// ICOMBDGT
							sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete5", formData);
							sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete5BudgetUpdate", formData); 
						
						
							//SLOGIC-BEGIN(P06-0000036)
							String p060000036 = CommonUtil.getSpecialCheckReturn(buyer,"P06-0000036","COL03_DATA"); // 권한특수로직
							if ("COWAY".equals(p060000036)){
								sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete6", formData);
						  }
							//SLOGIC-END
					}
				//	sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete5", formData);
				//	sqlSessionTemplate.update("common.mpso.setSysopOrderChangeBeforeDelete6", formData);
					
					
				}else{
					// 수주접수된 발주건은 발주정보수정 메인 화면에서 다시 조회 후 , 수주접수후 팝업 화면에서 발주정보를 수정하도록 한다.
				}	
				
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("발주삭제에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	
	
	@SuppressWarnings("unchecked")
	public String setSysopOrderChangeBeforeSave(Map<String,String>  formData, List<Object> gridData) { 
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String setSysopOrderChangeBeforeProcessTypeModify(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String setSysopOrderChangeBeforeAgentModify(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public String setCheckInterBizPoStatus(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	} 
	@SuppressWarnings("unchecked")
	public double getBuyerRateInfo(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return 0;
	}
	@SuppressWarnings("unchecked")
	public double getProcessTypeRateInfo(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return 0;
	}
	@SuppressWarnings("unchecked")
	public double getBuyerStandardRate(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return 0;
	}
	@SuppressWarnings("unchecked")
	public String getBuyerRateAdaptFlag(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	@SuppressWarnings("unchecked")
	public List<Map<String, String>> getTotProcessTypeRateInfo(Map<String,String>  formData, List<Object> gridData){
		String _rtnMsg = "저장완료.";

		try{
			for(int i=0; i < gridData.size(); i++){
				formData.putAll((Map<String, String>)gridData.get(i));
				
				// STEP1
				//sqlSessionTemplate.update("master.mpds.updateMasterMpDscropProtect", formData);
			}

		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("저장에 실패하였습니다.");
		}
		return null;
	}
	
	
	
	
	 
	public List<Map<String, String>> getApprovalTargetOeList(Map<String,String>  formData ) { 
		 List<Map<String, String>> list = null;
		try{
				list = sqlSessionTemplate.selectList("common.mpso.getApprovalTargetOeList", formData);
		} catch (Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException();
		}
		 return list;
	} 
	 
	public void modify_ICOMPODT_DOCU_PASSSTATUS(Map<String,String>  formData) {
		sqlSessionTemplate.update("common.mpso.modify_ICOMPODT_DOCU_PASSSTATUS", formData);
	}
	
	/*긴급발주변경*/
	@SuppressWarnings("unchecked")
	public String setSysopOrderUpdateEmegancyPo(Map<String,String>  formData , List<Object> gridData) {
		 String _rtnMsg = "선택한 발주를 긴급발주로 변경하였습니다.";
		
		try{

				sqlSessionTemplate.update("common.mpso.setSysopOrderUpdateEmegancyPo", formData);

			
		}catch(Exception e){
			LOGGER.error("SQL ERROR : ", e);
			throw new RuntimeException("긴급발주 변경에 실패하였습니다.");
		}
		return _rtnMsg;
	}
	
	 
	public double getBuyerRateInfo2(Map<String, String> pMap) { 
		return (Double)sqlSessionTemplate.selectOne("common.mpso.getBuyerRateInfo2", pMap);
	} 
	public double getKePBuyerRateInfo(Map<String, String> pMap) { 
		return (Double) sqlSessionTemplate.selectOne("common.mpso.getKePBuyerRateInfo", pMap);
	} 
	public String getBuyerRateAdaptFlag2(Map<String, String> pMap) { 
		return  sqlSessionTemplate.selectOne("common.mpso.getBuyerRateAdaptFlag2", pMap);
	} 
	public double getProcessTypeRateInfo2(Map<String, String> pMap) { 
		return  (Double)sqlSessionTemplate.selectOne("common.mpso.getProcessTypeRateInfo2", pMap);
	}
	  
	
	
}
