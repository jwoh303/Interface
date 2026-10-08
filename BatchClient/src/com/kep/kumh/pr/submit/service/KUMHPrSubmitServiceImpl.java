package com.kep.kumh.pr.submit.service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.kep.common.CommonProperty;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.kumh.pr.submit.dao.PrSubmitDao;
import com.kep.kumh.pr.submit.dao.PrSubmitDaoImpl;
import com.kkpc.KEP_MM_001.KEP_MM_001_DT_req_SOAPROW;
import com.kkpc.KEP_MM_001.KEP_MM_001_DT_res_SOAP;
import com.kkpc.KEP_MM_001.KEP_MM_001_SOProxy;

public class KUMHPrSubmitServiceImpl implements KUMHPrSubmitService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void execute() throws Exception{
		/**
		 * 주문 데이터 확인	
		 * 데이터 세팅
		 * 호출 및 처리 결과 저장 
		 */
		PrSubmitDao dao = new PrSubmitDaoImpl(); 
		
		//대상 조회
		List<Map<String,String>> map = dao.selectTargetList();
		
		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				List<Map<String,String>> pMaps = dao.selectPrList(map.get(i));
				Map<String, String> pMap = new HashMap<String, String>();
			
				int cnt = 0;
				int size = pMaps.size();
				try {
					KEP_MM_001_DT_req_SOAPROW[] prSubmitList = new KEP_MM_001_DT_req_SOAPROW[size];
					
					if(size > 0) {
						String strContent = "";
						String strEmail = "";
						String strName = "";
						for ( Map<String,String> iMap : pMaps) {
							pMap.put("DOC_NO",iMap.get("DOC_NO"));
							pMap.put("DOC_SEQ",iMap.get("DOC_SEQ"));
							pMap.put("STAU",iMap.get("STAU"));
							pMap.put("BUYER",iMap.get("BUYER"));
							if(iMap.get("EMAIL") != null && !strEmail.contains(iMap.get("EMAIL"))){
								strEmail += iMap.get("EMAIL")+";";
								strName += iMap.get("PREQ_NAME")+";";
							}
							log.debug("iMap" + iMap);
							
							prSubmitList[cnt++] = new KEP_MM_001_DT_req_SOAPROW(
									iMap.get("STAU")
									,iMap.get("LEBELN")
									,iMap.get("LEBELP")
									,iMap.get("ACCTASSCAT")
									,iMap.get("GL_ACCOUNT")
									,iMap.get("COSTCENTER")
									,iMap.get("WERKS")
									,iMap.get("EKGRP")
									,iMap.get("STGE_LOC")
									,iMap.get("INFNR")
									,iMap.get("MATNR")
									,iMap.get("TXZ01")
									,String.valueOf(iMap.get("MENGE"))
									,String.valueOf(iMap.get("NETPR"))
									,iMap.get("NETPRQ")
									,iMap.get("WAERS")
									,iMap.get("LIFNR")
									,iMap.get("ZTERM")
									,iMap.get("MWSKZ")
									,iMap.get("PREQ_NAME")
									,iMap.get("TEXT1")
									,iMap.get("TEXT2")
									,iMap.get("TEXT3")
									,iMap.get("TEXT4")
									,iMap.get("TEXT5")
									,iMap.get("TEXT6")
									,iMap.get("TEXT7")
									,iMap.get("BSART")
									,iMap.get("INCO1")
									,iMap.get("INCO2")
									,iMap.get("EEIND")
									,iMap.get("KDATB")
									,iMap.get("KDATE")
									,iMap.get("TESX2")
							);
							
							strContent += "<TR>";
							strContent += "<TD>";
							strContent += iMap.get("BUYER");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("DOC_NO");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("DOC_SEQ");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("MATNR");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += String.valueOf(iMap.get("MENGE"));
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += String.valueOf(iMap.get("NETPR"));
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("ACCTASSCAT");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("GL_ACCOUNT");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("COSTCENTER");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("WERKS");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("INFNR");
							strContent += "</TD>";
							strContent += "<TD>";
							strContent += iMap.get("PREQ_NAME");
							strContent += "</TD>";
							strContent += "</TR>";
						}	
						KEP_MM_001_SOProxy proxy = new KEP_MM_001_SOProxy(CommonProperty.getMM001_HTTP_url());
						KEP_MM_001_DT_res_SOAP arr = proxy.KEP_MM_001_SO(prSubmitList);
						pMap.put("ZRTCD",arr.getZRTCD());
						pMap.put("ZRTMSG",arr.getZRTMSG());
						if(pMap.get("ZRTCD").equals("N")) {
							pMap.put("ZRTCD","E");
							
							List<Map<String,String>> mailMaps = dao.selectMailInfo(pMap);
							if (mailMaps != null && mailMaps.size() > 0) {
								strName += mailMaps.get(0).get("NAME");
								strEmail += mailMaps.get(0).get("EMAIL");
							}
							String str = "";
							
							str += "<br><BODY><TABLE border='1'><TR>";
							str += "<TH>고객사</TH>";
							str += "<TH>결재번호</TH>";
							str += "<TH>결재순번</TH>";
							str += "<TH>품목코드<br>(MATNR)</TH>";
							str += "<TH>수량<br>(MENGE)</TH>";
							str += "<TH>단가<br>(NETPR)</TH>";
							str += "<TH>구매종류<br>(ACCTASSCAT)</TH>";
							str += "<TH>계정<br>(GL_ACCOUNT)</TH>";
							str += "<TH>코스트센터<br>(COSTCENTER)</TH>";
							str += "<TH>플랜트<br>(WERKS)</TH>";
							str += "<TH>구매 정보 레코드 번호<br>(INFNR)</TH>";
							str += "<TH>요청자</TH>";
							str += "</TR>";
							str += strContent;
							str += "<TR>";
							str += "<TD>오류내역</TD>";
							str += "<TD colspan = '11'>";
							str += pMap.get("ZRTMSG");
							str += "</TD>";
							str += "</TR></TABLE></BODY>";
							str += "<br><br>주문 데이터 전송 시 오류 발생 하였습니다. 확인 부탁드립니다.";
									
							pMap.put("MAIL_CONTENT", str);
							pMap.put("MAIL_EMAIL", strEmail);
							pMap.put("MAIL_NAME", strName);
							
							dao.insertMail(pMap);
						}else {
							pMap.put("EBELN",arr.getEBELN());
						}
						dao.updateResultData(pMap);
					}
				} catch (Exception e) {
					e.printStackTrace();
					log.info("KUMHPrService Error : " + e);
				}
				
			}
		}
	
	}

}
