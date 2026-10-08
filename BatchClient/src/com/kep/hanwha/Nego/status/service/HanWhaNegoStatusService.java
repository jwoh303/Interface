package com.kep.hanwha.Nego.status.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.hanwha.neo.branch.ss.approval.axisws.ApprovalServiceProxy;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hanwha.Nego.status.dao.HanWhaNegoStatusDao;
import com.kep.hanwha.RqRequest.status.dao.RqRequestStatusDao;

public class HanWhaNegoStatusService {

private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	public final static String MAN_SEND = "0";      //결재유형 - 기안자
	public final static String MAN_PASS = "1";  	// 결재유형 - 결재자
	public final static String MAN_REFER = "2"; 	// 결재유형 - 참조자
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
	
	public void execute() {
		
		HanWhaNegoStatusDao dao = new HanWhaNegoStatusDao();
		
		try {
			List<Map<String, String>> pIdList	= dao.getAppList();
			com.hanwha.neo.branch.ss.approval.vo.MisKey miskey = new com.hanwha.neo.branch.ss.approval.vo.MisKey();
			com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatus ApprovalDocumentStatus = new com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatus();
			//com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey Eaglemiskey = new com.hanwhaEagle.neo.branch.ss.approval.vo.MisKey();
			//com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatus EagleApprovalDocumentStatus = new com.hanwhaEagle.neo.branch.ss.approval.vo.ApprovalDocumentStatus();
			com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey cleverseMiskey = new com.hanwhaCleverse.neo.branch.ss.approval.vo.MisKey();
			com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatus cleverseApprovalDocumentStatus = new com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatus();
			
			int size = pIdList.size();
		
			ApprovalServiceProxy proxy = new ApprovalServiceProxy(CommonProperty.getDB_CONN());
			//com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalServiceProxy EagleProxy = new com.hanwhaEagle.neo.branch.ss.approval.axisws.ApprovalServiceProxy(CommonProperty.getDB_CONN());
			com.hanwhaCleverse.neo.branch.ss.approval.axisws.ApprovalServiceProxy cleverseProxy = new com.hanwhaCleverse.neo.branch.ss.approval.axisws.ApprovalServiceProxy(CommonProperty.getDB_CONN());
			
			for (Map<String,String> iMap : pIdList) {
				if("501".equals(iMap.get("COMPANYID"))) {		
					cleverseMiskey.setMisDocId(iMap.get("APPR_ID"));
					cleverseMiskey.setSystemId(iMap.get("SYSTEM_ID"));
					
					cleverseApprovalDocumentStatus = cleverseProxy.getStatusByMisId(cleverseMiskey);
					
					SetEagleApproval(cleverseApprovalDocumentStatus, iMap);
				} else {
					miskey.setMisDocId(iMap.get("APPR_ID"));
					miskey.setSystemId(iMap.get("SYSTEM_ID"));
					
					ApprovalDocumentStatus = proxy.getStatusByMisId(miskey);
					
					SetApproval(ApprovalDocumentStatus, iMap);
				}				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("AppStatusService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
public void SetApproval(com.hanwha.neo.branch.ss.approval.vo.ApprovalDocumentStatus ApprovalDocumentStatus, Map<String,String> iMap) {
		
		HanWhaNegoStatusDao dao = new HanWhaNegoStatusDao();
		
		Map<String,Object> pMap = new HashMap<String,Object>();
		
		String apprId	= ApprovalDocumentStatus.getMisDocId();
		String arrpSeq	= null;
		String apprDocStatusCd	= Integer.toString(ApprovalDocumentStatus.getStatus());	// 결재상태CD(1:진행, 2:완료 (승인), 3:반려 (반송), 4:상신취소)
		com.hanwha.neo.branch.ss.approval.vo.SignerInfo[] SignerInfoList = ApprovalDocumentStatus.getSignerInfos();
		String apprLineStatusCd	= null; //0 : 미결, 1 : 승인, 2: 반려, 3 : 전결
		String passStatus	= null;
		String passProgress	= null;
		String passKn		= null;
		String cur_order_no	= null;
		String change_yn = null;
		
		SimpleDateFormat fm = new SimpleDateFormat("yyyyMMddHHmmss");
		String end_date = null;
		Date date = null;
		
		try {
				System.out.println("apprDocStatusCd : " + apprDocStatusCd); 
			if ("1, 2, 3".indexOf(apprDocStatusCd) > -1) {
				
				pMap.put("APPR_ID", apprId);
				
				for (com.hanwha.neo.branch.ss.approval.vo.SignerInfo SignerInfo : SignerInfoList) {
					
					Map<String, String> tMap	= new HashMap<String, String>();
					passStatus	= STATUS_PING;
					passKn		= null;
					cur_order_no	= null;
					change_yn = "N";
					
					end_date = SignerInfo.getEndDate();
					
					if (end_date != null) {
						date = fm.parse(end_date);
					}
					
					pMap.put("USERID", SignerInfo.getUserId());
					tMap	= dao.getAppInfo(pMap);
					
					if (tMap != null) {
						apprLineStatusCd = Integer.toString(SignerInfo.getStatus());
						tMap.put("COMMENT", SignerInfo.getComment());
						tMap.put("APPRLINESTATUSCD", apprLineStatusCd);
						
						if ("1, 3".indexOf(apprLineStatusCd) > -1) { // 1.승인 , 3. 전결
							passKn = KIND_PASS; //승인
						}else if ("2".indexOf(apprLineStatusCd) > -1) { // 2.반려
							passKn = KIND_RET; //반려
						}
					} else {
						change_yn = "Y";
					}
					if (passKn != null) {
						tMap.put("PASS_KN", passKn);
						tMap.put("PASS_DATE", SignerInfo.getEndDate() );
						tMap.put("PASS_ADD", SignerInfo.getComment());
						
						if ( KIND_PASS.equals(passKn) ) {
							dao.updateAppCurOrder(tMap);
							tMap.put("PASS_TP", MAN_PASS);	// 결재
							
							List<Map<String, String>> nextAppLine	= dao.getNextAppLine(tMap);
							
							if (nextAppLine != null && nextAppLine.size() > 0) {
								
								Map<String, String> _cur_order	= nextAppLine.get(0);
								
								if (_cur_order == null) {
									passStatus	= STATUS_COMP;	// 최종 결재
								} else {
									cur_order_no	= _cur_order.get("ORDER_NO");
									
									if( "".equals(cur_order_no) ) {
										passStatus	= STATUS_COMP;	// 최종 결재
									}
								}
							} else {
								passStatus	= STATUS_COMP;	//	최종 결재
							}
						} else if (KIND_RET.equals(passKn)) {
							
							dao.updateAppCurOrder(tMap);
							passStatus = STATUS_RET;
							
							List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
							
							for(int k = 0 ; k < tList.size() ; k++ ) {
								Map<String, String> kMap	= tList.get(k);
							
								kMap.put("RECV_FLAG", "GA");

								dao.updateNegoCancel(kMap);
							}
						}
						tMap.put("PASS_STATUS", passStatus);
						tMap.put("CUR_ORDER_NO", cur_order_no);
						
						dao.updateApl(tMap);
						
						if ( STATUS_PING.equals(passStatus) ) {
							// 진행중.
							dao.updateApping(tMap);
							
						}
					} 
				} // for 문 끝
				
				if ( "2,3".indexOf(apprDocStatusCd) > -1) {

					pMap.put("RTN_MSG", apprDocStatusCd);
					pMap.put("RTN_FLAG", "Y");
					pMap.put("END_DATE", date);
					
					dao.updateAppStatus(pMap);
					log.debug("Approval Process End   : " + apprId);
					
					if ("2".equals(apprDocStatusCd)) {
						
						if("Y".equals(change_yn)) {
							iMap.put("PASS_KN",KIND_PASS);
							dao.updateNegoStatus_ChangeLine(iMap);
						}
						
						pMap.put("PASS_STATUS", STATUS_COMP);
						
						List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
						
						for(int k = 0 ; k < tList.size() ; k++ ) {
							Map<String, String> kMap	= tList.get(k);
							
							dao.HANHWA_RQDT_CONFIRM(kMap);
						}
						
					} else {
						
						if("Y".equals(change_yn)) {
							iMap.put("PASS_KN",KIND_RET);
							dao.updateNegoStatus_ChangeLine(iMap);
							
							List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
							
							for(int k = 0 ; k < tList.size() ; k++ ) {
								Map<String, String> kMap	= tList.get(k);
								
								kMap.put("RECV_FLAG", "GA");

								dao.updateNegoCancel(kMap);
							}
						}
						pMap.put("PASS_STATUS", STATUS_RET);
					}
					dao.updateAppFinal2(pMap);
					
				}
				
			} else  { // 상신취소
				
				end_date = SignerInfoList[0].getEndDate();
				
				date = fm.parse(end_date);
				
				pMap.put("APPR_ID", apprId);
				pMap.put("END_DATE", date);
				
				if ("4".equals(apprDocStatusCd)) {
					pMap.put("PASS_ADD", "Circle 상신취소");
				}
				
				dao.modifyICOGDOCU_PASSSTATUS(pMap);
				dao.modifyICOGPASSLN_PASSKN(pMap);
				
				List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
				
				for(int i = 0 ; i < tList.size() ; i++ ) {
					Map<String, String> tMap	= tList.get(i);
					
					tMap.put("RECV_FLAG", "GA");

					dao.updateNegoCancel(tMap);
				}
				
				pMap.put("RTN_MSG", apprDocStatusCd);
				pMap.put("RTN_FLAG", "Y");
				
				System.out.println("pMap2 : " + pMap);
				dao.updateAppStatus(pMap);
			}

		} catch (Exception e) {
			log.error("APPR_STATUS Error : " + e.getMessage());
			e.printStackTrace();
		}
		
	}

public void SetEagleApproval(com.hanwhaCleverse.neo.branch.ss.approval.vo.ApprovalDocumentStatus ApprovalDocumentStatus, Map<String,String> iMap) {
	
	HanWhaNegoStatusDao dao = new HanWhaNegoStatusDao();
	
	Map<String,Object> pMap = new HashMap<String,Object>();
	
	String apprId	= ApprovalDocumentStatus.getMisDocId();
	String arrpSeq	= null;
	String apprDocStatusCd	= Integer.toString(ApprovalDocumentStatus.getStatus());	// 결재상태CD(1:진행, 2:완료 (승인), 3:반려 (반송), 4:상신취소)
	com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo[] SignerInfoList = ApprovalDocumentStatus.getSignerInfos();
	String apprLineStatusCd	= null; //0 : 미결, 1 : 승인, 2: 반려, 3 : 전결
	String passStatus	= null;
	String passProgress	= null;
	String passKn		= null;
	String cur_order_no	= null;
	String change_yn = null;
	
	SimpleDateFormat fm = new SimpleDateFormat("yyyyMMddHHmmss");
	String end_date = null;
	Date date = null;
	
	try {
			System.out.println("apprDocStatusCd : " + apprDocStatusCd); 
		if ("1, 2, 3".indexOf(apprDocStatusCd) > -1) {
			
			pMap.put("APPR_ID", apprId);
			
			for (com.hanwhaCleverse.neo.branch.ss.approval.vo.SignerInfo SignerInfo : SignerInfoList) {
				
				Map<String, String> tMap	= new HashMap<String, String>();
				passStatus	= STATUS_PING;
				passKn		= null;
				cur_order_no	= null;
				change_yn = "N";
				
				end_date = SignerInfo.getEndDate();
				
				if (end_date != null) {
					date = fm.parse(end_date);
				}
				
				pMap.put("USERID", SignerInfo.getUserId());
				tMap	= dao.getAppInfo(pMap);
				
				if (tMap != null) {
					apprLineStatusCd = Integer.toString(SignerInfo.getStatus());
					tMap.put("COMMENT", SignerInfo.getComment());
					tMap.put("APPRLINESTATUSCD", apprLineStatusCd);
					
					if ("1, 3".indexOf(apprLineStatusCd) > -1) { // 1.승인 , 3. 전결
						passKn = KIND_PASS; //승인
					}else if ("2".indexOf(apprLineStatusCd) > -1) { // 2.반려
						passKn = KIND_RET; //반려
					}
				} else {
					change_yn = "Y";
				}
				if (passKn != null) {
					tMap.put("PASS_KN", passKn);
					tMap.put("PASS_DATE", SignerInfo.getEndDate() );
					tMap.put("PASS_ADD", SignerInfo.getComment());
					
					if ( KIND_PASS.equals(passKn) ) {
						dao.updateAppCurOrder(tMap);
						tMap.put("PASS_TP", MAN_PASS);	// 결재
						
						List<Map<String, String>> nextAppLine	= dao.getNextAppLine(tMap);
						
						if (nextAppLine != null && nextAppLine.size() > 0) {
							
							Map<String, String> _cur_order	= nextAppLine.get(0);
							
							if (_cur_order == null) {
								passStatus	= STATUS_COMP;	// 최종 결재
							} else {
								cur_order_no	= _cur_order.get("ORDER_NO");
								
								if( "".equals(cur_order_no) ) {
									passStatus	= STATUS_COMP;	// 최종 결재
								}
							}
						} else {
							passStatus	= STATUS_COMP;	//	최종 결재
						}
					} else if (KIND_RET.equals(passKn)) {
						
						dao.updateAppCurOrder(tMap);
						passStatus = STATUS_RET;
						
						List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
						
						for(int k = 0 ; k < tList.size() ; k++ ) {
							Map<String, String> kMap	= tList.get(k);
						
							kMap.put("RECV_FLAG", "GA");

							dao.updateNegoCancel(kMap);
						}
					}
					tMap.put("PASS_STATUS", passStatus);
					tMap.put("CUR_ORDER_NO", cur_order_no);
					
					dao.updateApl(tMap);
					
					if ( STATUS_PING.equals(passStatus) ) {
						// 진행중.
						dao.updateApping(tMap);
						
					}
				} 
			} // for 문 끝
			
			if ( "2,3".indexOf(apprDocStatusCd) > -1) {

				pMap.put("RTN_MSG", apprDocStatusCd);
				pMap.put("RTN_FLAG", "Y");
				pMap.put("END_DATE", date);
				
				dao.updateAppStatus(pMap);
				log.debug("Approval Process End   : " + apprId);
				
				if ("2".equals(apprDocStatusCd)) {
					
					if("Y".equals(change_yn)) {
						iMap.put("PASS_KN",KIND_PASS);
						dao.updateNegoStatus_ChangeLine(iMap);
					}
					
					pMap.put("PASS_STATUS", STATUS_COMP);
					
					List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
					
					for(int k = 0 ; k < tList.size() ; k++ ) {
						Map<String, String> kMap	= tList.get(k);
						
						dao.HANHWA_RQDT_CONFIRM(kMap);
					}
					
				} else {
					
					if("Y".equals(change_yn)) {
						iMap.put("PASS_KN",KIND_RET);
						dao.updateNegoStatus_ChangeLine(iMap);
						
						List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
						
						for(int k = 0 ; k < tList.size() ; k++ ) {
							Map<String, String> kMap	= tList.get(k);
							
							kMap.put("RECV_FLAG", "GA");

							dao.updateNegoCancel(kMap);
						}
					}
					pMap.put("PASS_STATUS", STATUS_RET);
				}
				dao.updateAppFinal2(pMap);
				
			}
			
		} else  { // 상신취소
			
			end_date = SignerInfoList[0].getEndDate();
			
			date = fm.parse(end_date);
			
			pMap.put("APPR_ID", apprId);
			pMap.put("END_DATE", date);
			
			if ("4".equals(apprDocStatusCd)) {
				pMap.put("PASS_ADD", "Circle 상신취소");
			}
			
			dao.modifyICOGDOCU_PASSSTATUS(pMap);
			dao.modifyICOGPASSLN_PASSKN(pMap);
			
			List<Map<String, String>> tList	= dao.selectNegoCancelInfoList(pMap);
			
			for(int i = 0 ; i < tList.size() ; i++ ) {
				Map<String, String> tMap	= tList.get(i);
				
				tMap.put("RECV_FLAG", "GA");

				dao.updateNegoCancel(tMap);
			}
			
			pMap.put("RTN_MSG", apprDocStatusCd);
			pMap.put("RTN_FLAG", "Y");
			
			System.out.println("pMap2 : " + pMap);
			dao.updateAppStatus(pMap);
		}

	} catch (Exception e) {
		log.error("APPR_STATUS Error : " + e.getMessage());
		e.printStackTrace();
	}
	
}
}
