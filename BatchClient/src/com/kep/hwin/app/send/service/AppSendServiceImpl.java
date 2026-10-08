package com.kep.hwin.app.send.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.hwin.app.send.dao.AppSendDao;
import com.kep.hwin.app.send.dao.AppSendDaoImpl;
import com.stw.kep.ws.service.M2KEP0001M2016.M2KEP0001M2016Proxy;
import com.stw.kep.ws.service.M2KEP0001M2016.T_APPR_LINE_OUT_STEP;
import com.stw.kep.ws.service.M2KEP0001M2016.T_APPR_OUT_STEP;

public class AppSendServiceImpl implements AppSendService {
	
	private static Logger log	= Logger.getLogger( AppSendServiceImpl.class.getName() );
	
	@Override
	public void execute() {
		AppSendDao dao	= new AppSendDaoImpl();
		
		Map<String, String> pMap = new HashMap<String, String>();
		
		try {
			log.debug("AppSendService Start...");
			
			pMap.put("BUYER_ID", "HWIN");
			
			List<Map<String, String>> targetList	= dao.selectIFTargetList(pMap);
			
			if ( targetList.size() > 0) {
				
				pMap.clear();
				pMap	= targetList.get(0);

				List<Map<String, String>> prList	= dao.selectIFAppPrList(pMap);
				
				log.debug("Count : " + prList.size());

				Map<String, String> appData	= dao.selectIFAppInfo(pMap);
				
				StringBuffer contents	= new StringBuffer();

				contents.append("<pre>");
				contents.append(appData.get("DOCU_CONT"));
				contents.append("</pre>");
				contents.append("<br><hr><br>\n");
				contents.append("<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>\n");
				contents.append("<html>\n");
				contents.append("<head>\n");
				contents.append("<meta http-equiv='Content-Type' content='text/html; charset=euc-kr'>\n");
				contents.append("</head>\n");
				contents.append("<body leftmargin='10' topmargin='10' marginwidth='0' marginheight='0'>\n");
				contents.append("<table width='720' border='0' cellspacing='0' cellpadding='0'>\n");
				contents.append("<tr>\n");
				contents.append("<td>\n");
				contents.append("<table width='100%' border='0' cellpadding='2' cellspacing='1' bgcolor='#d6e0f2' style='font-family:Dotum;font-size:9pt;color:#555555;word-break:break-all'>\n");

				contents.append("<tr bgcolor='#F0F6FB' align='center'>\n");
				contents.append("<td width='80' height='24'>품목코드</td>\n");
				contents.append("<td width='200'>품목명</td>\n");
				contents.append("<td width='50'>단위</td>\n");
				contents.append("<td width='125'>예산부서</td>\n");
				contents.append("<td width='125'>계정</td>\n");
				contents.append("<td width='70'>주문일자</td>\n");
				contents.append("<td width='70'>희망납기</td>\n");
				contents.append("</tr>\n");
				contents.append("<tr bgcolor='#F0F6FB' align='center'>\n");
				contents.append("<td width='80' height='24'>주문번호</td>\n");
				contents.append("<td width='200'>규격</td>\n");
				contents.append("<td width='50'>통화</td>\n");
				contents.append("<td width='125'>공급사명</td>\n");
				contents.append("<td width='125'>수량</td>\n");
				contents.append("<td width='70'>단가</td>\n");
				contents.append("<td width='70'>금액</td>\n");
				contents.append("</tr>\n");
				
				// #ffffff #F5F5F5
				String bgColor	= "";
				for(int i = 0 ; i < prList.size() ; i++ ) {
					
					Map<String, String> tMap	= prList.get(i);
					
					if (i%2 == 0) bgColor	= "#ffffff";
					else bgColor	= "#F5F5F5";
					
					contents.append("<tr bgcolor="+bgColor+">\n");
					contents.append("<td height='24' align='left'>"+tMap.get("BUYER_ITEM_NO")+"</td>\n");
					contents.append("<td><font title='"+tMap.get("DESCRIPTION")+"'>"+tMap.get("DESCRIPTION")+"</font></td>\n");
					contents.append("<td align='center'>"+tMap.get("UNIT_MEASURE")+"</td>\n");
					contents.append("<td><font title='"+tMap.get("BUDGET_DEPT")+"'>"+tMap.get("BUDGET_DEPT")+"</font></td>\n");
					contents.append("<td><font title='"+tMap.get("ACCOUNT_TYPE")+"'>"+tMap.get("ACCOUNT_TYPE")+"</font></td>\n");
					contents.append("<td align='center'>"+tMap.get("ADD_DATE")+"</td>\n");
					contents.append("<td align='center'>"+tMap.get("RD_DATE")+"</td>\n");
					contents.append("</tr>\n");
					contents.append("<tr height=30 bgcolor="+bgColor+">\n");
					contents.append("<td height='24' align='left'>"+tMap.get("PR_NO")+"<br></td>\n");
					contents.append("<td><font title='"+tMap.get("SPECIFICATION")+"'>"+tMap.get("SPECIFICATION")+"</font></td>\n");
					contents.append("<td align='center'>"+tMap.get("CUR")+"</td>\n");
					contents.append("<td><font title='"+tMap.get("AGENT_NAME")+"'>"+tMap.get("AGENT_NAME")+"</font></td>\n");
					contents.append("<td align='right'>"+tMap.get("TARGET_QTY")+"</td>\n");
					contents.append("<td align='right'>"+tMap.get("PRICE")+"&nbsp;</td>\n");
					contents.append("<td align='right'>"+tMap.get("AMT")+"&nbsp;</td>\n");
					contents.append("</tr>\n");
				}
				
				contents.append("</table>\n");
				contents.append("</td>\n");
				contents.append("</tr>\n");
				contents.append("</table>\n");
				contents.append("</body>\n");
				contents.append("</html>\n");
				
				appData.put("CONTENTS",contents.toString());

				dao.insertIfAplSend(appData);
				dao.insertIfApmSend(appData);
				
				// 웹서비스 호출 로직
				// 1. SELECT T_APPR_OUT_STEP DATA
				// 2. SELECT T_APPR_LINE_OUT_STEP DATA
				// 3. MAPPING DATA TO T_APPR_OUT_STEP OBJECT
				// 4. MAPPING DATA TO T_APPR_LINE_OUT_STEP OBJECT
				
				// 1. SELECT DATA
				Map<String, String> apmData	= dao.selectHanhwaDocu(appData);
				List<Map<String, String>> aplList	= dao.selectHanhwaPassln(appData);
				
				// Call Web Service
				M2KEP0001M2016Proxy proxy1	= new M2KEP0001M2016Proxy();
				
				log.debug("Endpoint : " + proxy1.getEndpoint());
				
				T_APPR_OUT_STEP[]	apprOut	= new T_APPR_OUT_STEP[1];
				T_APPR_LINE_OUT_STEP[]	apprLineOut	= new T_APPR_LINE_OUT_STEP[aplList.size()];

				for(int i = 0 ; i < aplList.size() ; i++) {
					T_APPR_LINE_OUT_STEP tApprLine	= new T_APPR_LINE_OUT_STEP();
					Map<String, String> tMap	= aplList.get(i);
					
					tApprLine.setAPPRID(tMap.get("APPRID"));
					tApprLine.setAPPRSEQ(tMap.get("APPRSEQ"));
					tApprLine.setAPPRACTIONSEQ(tMap.get("APPRSEQ"));
					tApprLine.setAPPRACTIONCD(tMap.get("APPRACTIONCD"));
					tApprLine.setAPPRSTATUSCD("0");	// 0
					tApprLine.setAPPRUID(tMap.get("LEGACY_USER_ID"));
					tApprLine.setAPPRNM(tMap.get("USER_NAME_LOC"));
					tApprLine.setAPPRDEPTNM(tMap.get("APPRDEPTNM"));
					tApprLine.setAPPRGRDNM(tMap.get("APPRGRDNM"));
					tApprLine.setINSERTUID(apmData.get("LEGACY_USER_ID"));
					tApprLine.setUPDATEUID(apmData.get("LEGACY_USER_ID"));
					tApprLine.setAPPRSGID(tMap.get("LEGACY_USER_ID"));
					
					apprLineOut[i]	= tApprLine;
				}
				
				T_APPR_OUT_STEP tApprOut	= new T_APPR_OUT_STEP();
				tApprOut.setAPPRID(apmData.get("APPRID"));
				tApprOut.setSYSID("HTW_KEP1");	// HTW_KEP1
				tApprOut.setSGSVRLOCANM("KR");	// KR
				tApprOut.setAPPRCONTENTSCD("H");	// H
				tApprOut.setAPPRCONTENTSCLOB(appData.get("CONTENTS"));
				tApprOut.setAPPRTRANSSTATUSCD("1");	// 1:상신
				tApprOut.setAPPRTITLE(apmData.get("SUBJECT"));
				tApprOut.setAPPRSTATUSCD("0");	// 0:상신중
				tApprOut.setAPPRTYPEID("KEP_001");	// KEP_001
				tApprOut.setINSERTUID(apmData.get("LEGACY_USER_ID"));
				tApprOut.setUPDATEUID(apmData.get("LEGACY_USER_ID"));
				tApprOut.setAPPRSUBMITDT(apmData.get("ADD_DATE"));	// MM/DD/YYYY HH24:MI:SS
				tApprOut.setAPPRREVNO("1");
				tApprOut.setCOMPCD(apmData.get("COMP_CD"));
				tApprOut.setSHIFTDATA(apmData.get("SHIFT_DATA"));
				tApprOut.setT_APPR_LINE_OUT_STEP(apprLineOut);
				
				apprOut[0]	= tApprOut;
				
				// 전송처리...
				proxy1.process(apprOut);
			} else {
				log.debug("Taget List Count is 0....");
			}
			
			log.debug("AppSendService End...");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
