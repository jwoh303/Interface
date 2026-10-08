package com.kep.hwDefense.app.status.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hwDefense.app.status.dao.AppStatusDao;
import com.kep.hwDefense.app.status.dao.AppStatusDaoImpl;

import hdli.cs.ws.server.T_APPR_LINE_IN_STEP;
import hdli.cs.ws.server.T_APPR_STATUS_IN_STEP;
import hdli.cs.ws.server.T_APPR_STATUS_LIST_CALL;
import hdli.cs.ws.server.WSKP002WebServiceProxy;

public class HWDFAppStatusServiceImpl implements HWDFAppStatusService {
	
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
	
	@Override
	public void execute() {
		
		AppStatusDao dao	= new AppStatusDaoImpl();
		T_APPR_STATUS_LIST_CALL[] req = null;
		
		try {
			List<Map<String, String>> pIdList	= dao.getAppList();
			int size = pIdList.size();
			
			if (size > 0) {
				
				req = new T_APPR_STATUS_LIST_CALL[size];
				for( int i = 0 ; i < size ; i++ ) {
					T_APPR_STATUS_LIST_CALL tItem = new T_APPR_STATUS_LIST_CALL();
					Map<String, String> tMap = pIdList.get(i);
					tItem.setAPPRID(tMap.get("APPR_ID"));
					req[i] = tItem;
					
					log.debug("* APPR_ID : " + tMap.get("APPR_ID"));
				}
				
				WSKP002WebServiceProxy proxy = new WSKP002WebServiceProxy(CommonProperty.getDB_CONN());
				
				T_APPR_STATUS_IN_STEP[]	rtnList	= proxy.process(req);
				
				for(int i = 0 ; i < rtnList.length ; i++ ) {
					approval(rtnList[i]);
				}
			}
		} catch (Exception e) {
			log.error("AppStatusService Error : " + CommonUtil.printStackTraceToString(e));
		}
	}
	
	private boolean approval(T_APPR_STATUS_IN_STEP pItem) throws Exception {
		AppStatusDao dao	= new AppStatusDaoImpl();
		boolean bResult	= false;
		Map<String, String> pMap	= new HashMap<String, String>();
		
		String apprId	= pItem.getAPPRID();
		String arrpSeq	= null;
		String apprDocStatusCd	= pItem.getAPPRSTATUSCD();	// 결재상태CD(0:상신중,1:결재진행중,2:완결,3:반려,4:상신취소,5:전결,6:후완결,W:작성중)
		String apprLineStatusCd	= null;
		String passStatus	= null;
		String passProgress	= null;
		String passKn		= null;
		String cur_order_no	= null;
		T_APPR_LINE_IN_STEP[] appLineList	= null;
		
		try {
			dao.saveAPPR_STATUS_HwDefense(CommonUtil.convertVoToMap(pItem, "T01"));
		} catch (Exception e) {
			log.error("APPR_STATUS Error : " + e.getMessage());
			e.printStackTrace();
		}
		
		if ("1, 2, 3".indexOf(apprDocStatusCd) > -1) {
			// 1:결재진행중,2:완결,3:반려  처리.
			
			pMap.put("APPR_ID", apprId);
			log.info("Approval Process Start : " + apprId + " / " + apprDocStatusCd);
			appLineList	= pItem.getT_APPR_LINE_IN_STEP();
			
			if ( appLineList != null ) {

				for( int i = 0 ; i < appLineList.length ; i++ ) {
					Map<String, String> tMap	= new HashMap<String, String>();
					passStatus	= STATUS_PING;
					passKn		= null;
					cur_order_no	= null;

					log.debug("App Info : " + appLineList[i].getAPPRID() + " / " + appLineList[i].getAPPRNM() + " / " + appLineList[i].getAPPRUID() + " / " + appLineList[i].getINSERTUID() + " / " + appLineList[i].getUPDATEUID());
					
					pMap.put("APPR_ID", appLineList[i].getAPPRID() );
					tMap	= dao.getAppInfo(pMap);

					if (tMap != null) {
						apprLineStatusCd	= appLineList[i].getAPPRSTATUSCD();	
						// 액션코드 (0:기안, 1:결재, 2:합의, 3:후결, 7:병렬결재, 4:병렬합의, 9:통보 ) 
						// 단계별 처리 결과 결재상태CD (0:미결, 1:결재, 5:자동결재, 2:반려, 3:전결)
						
						if ("11, 21, 71, 41, 13, 23, 73, 43, 15, 25, 75, 45".indexOf(apprLineStatusCd) > -1) {
							passKn	= KIND_PASS;	// 결재
						} else if ("12, 22, 72, 42".indexOf(apprLineStatusCd) > -1) {
							passKn	= KIND_RET;		// 반려
						}
						
						log.debug("COMPANY : " + tMap.get("COMPANY"));
						log.debug("DOCU_NO : " + tMap.get("DOCU_NO"));
						log.debug("apprLineStatusCd : " + apprLineStatusCd);
						log.debug("passKn : " + passKn);
					}
					
					if (passKn != null) {
						tMap.put("PASS_KN", passKn);
						tMap.put("PASS_DATE", appLineList[i].getAPPRCONFIRMDT() );
						tMap.put("PASS_ADD", appLineList[i].getAPPROPINION());
						
						if ( KIND_PASS.equals(passKn) ) {
							// 현재 
							dao.updateAppCurOrder(tMap);
							tMap.put("PASS_TP", MAN_PASS);	// 결재
							
							// 
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
							
						} else if ( KIND_RET.equals(passKn) ) {
							//
							dao.updateAppCurOrder(tMap);
							passStatus	= STATUS_RET;	//	반려

							List<Map<String, String>> tList	= dao.selectPrCancelInfoList(pMap);
							
							for(int k = 0 ; k < tList.size() ; k++ ) {
								Map<String, String> kMap	= tList.get(k);
								
								tMap.put("RECV_FLAG", "PR");

								dao.updatePrCancel(kMap);
								dao.updateReturnPrBudget(kMap);
							}
						}

						tMap.put("PASS_STATUS", passStatus);
						tMap.put("CUR_ORDER_NO", cur_order_no);

						log.debug("PASS_STATUS : " + passStatus);
						log.debug("CUR_ORDER_NO : " + cur_order_no);
						
						if ( STATUS_PING.equals(passStatus) ) {
							// 진행중.
							dao.updateApping(tMap);
						}
					} else {
						arrpSeq	= Integer.toString( appLineList[i].getAPPRSEQ() );
						log.debug("Check ApprStatusCD --> " + apprId + " / " + arrpSeq + " / " + apprLineStatusCd);
					}
				}
			}

			if ( "2,3".indexOf(apprDocStatusCd) > -1) {

				pMap.put("RTN_MSG", apprDocStatusCd);
				pMap.put("RTN_FLAG", "Y");
				dao.updateAppStatus(pMap);
				log.debug("Approval Process End   : " + apprId);
				
				if ("2".equals(apprDocStatusCd)) {
					pMap.put("PASS_STATUS", STATUS_COMP);
				} else {
					pMap.put("PASS_STATUS", STATUS_RET);
				}
				dao.updateAppFinal2(pMap);
			}
		} else if ("4, F".indexOf(apprDocStatusCd) > -1) {
			
			pMap.put("APPR_ID", apprId);
			
			if ("4".equals(apprDocStatusCd)) {
				pMap.put("PASS_ADD", "이글 오피스 상신취소");
			} else if ("F".equals(apprDocStatusCd) ) {
				pMap.put("PASS_ADD", pItem.getERRORDETAIL());
			}
			log.debug("Approval Cancel Start : " + apprId);

			dao.modifyICOGDOCU_PASSSTATUS(pMap);
			dao.modifyICOGPASSLN_PASSKN(pMap);
			
			List<Map<String, String>> tList	= dao.selectPrCancelInfoList(pMap);
			
			for(int i = 0 ; i < tList.size() ; i++ ) {
				Map<String, String> tMap	= tList.get(i);
				
				tMap.put("RECV_FLAG", "PD");

				dao.updatePrCancel(tMap);
				dao.updateReturnPrBudget(tMap);
			}
			
			pMap.put("RTN_MSG", apprDocStatusCd);
			pMap.put("RTN_FLAG", "Y");
			dao.updateAppStatus(pMap);
			
			log.debug("Approval Cancel End   : " + apprId);
		}
		
		return bResult;
	}
}
