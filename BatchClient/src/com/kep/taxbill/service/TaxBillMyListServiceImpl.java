package com.kep.taxbill.service;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.w3c.dom.Document;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.taxbill.dao.TaxBillMyListDao;
import com.kep.taxbill.dao.TaxBillMyListDaoImpl;

@SuppressWarnings("unchecked")
public class TaxBillMyListServiceImpl implements TaxBillMyListService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private TaxBillMyListDao dao = new TaxBillMyListDaoImpl();

	@Override
	public void execute() {

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {

			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));

			List<Map<String, String>> tbList	= dao.selectSearchMyListCondition();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( tbList.size() ));

			String tax_url = "";

			for (Map<String, String> tMap : tbList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("MessageId", tMap.get("MESSAGEID"));
				jsonObj.put("Signal", tMap.get("SIGNAL"));
				jsonObj.put("RequestTime", tMap.get("REQUESTTIME"));
				jsonObj.put("SendComRegno", tMap.get("SENDCOMREGNO"));
				jsonObj.put("AuthToken", tMap.get("AUTHTOKEN"));
				jsonObj.put("ServiceCode", tMap.get("SERVICECODE"));
				jsonObj.put("SearchFromDate", tMap.get("SEARCHFROMDATE"));
				jsonObj.put("SearchToDate", tMap.get("SEARCHTODATE"));
				jsonObj.put("ListTypeCode", tMap.get("LISTTYPECODE"));
//				if ( "2".equals(CommonProperty.getDB_CONN()) ) {
//					tax_url = "https://api.smartbill.co.kr/sb-api/request/";
//				} else {
//					tax_url = "https://demoapi.smartbill.co.kr/sb-api/request/";
//				}
				
				tax_url = "https://api.smartbill.co.kr/sb-api/request/";
				
				URL url = new URL(tax_url);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("POST");
				conn.setUseCaches(false);
				conn.setDoInput(true);
				conn.setDoOutput(true);
				conn.setConnectTimeout(10000);
				conn.setRequestProperty("Content-Type", "application/json");
				conn.setRequestProperty("Accept", "application/json");
				DataOutputStream os = new DataOutputStream(conn.getOutputStream());
				os.write(jsonObj.toString().getBytes());
				os.flush();
				os.close();
				
				BufferedReader br;

				String response = "";
				if(null != conn){
					br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
					String line = null;
					while((line = br.readLine()) != null){
						response += line + "\n";						
					}
				}
				log.info("Period : " + tMap.get("SEARCHFROMDATE") + " ~ " + tMap.get("SEARCHTODATE"));
				log.debug("response="+response);
				
	            JSONParser jsonParser = new JSONParser();
	            
	            try {

		            JSONObject jsonResponse = (JSONObject) jsonParser.parse(response);
					
					if("30000".equalsIgnoreCase((String)jsonResponse.get("ResultCode"))){
						JSONObject jsonResultDataSet = (JSONObject) jsonResponse.get("ResultDataSet");
						JSONArray jsonArray = (JSONArray) jsonResultDataSet.get("Table");
						int totalCount = jsonArray.size();
						log.debug(" SENDCOMREGNO : " + tMap.get("SENDCOMREGNO") +" / SEARCHCOMREGNO : "+tMap.get("SEARCHCOMREGNO") +" ==> 결과건수 : "+ jsonArray.size());
						
						if (0 < totalCount) {
							for( int i = 0 ; i < totalCount ; i++ ) {
								
								JSONObject jObj = (JSONObject)jsonArray.get(i);
								
								Map<String, Object> pMap = new HashMap<String, Object>();
								
								log.debug("AMEND_CODE : " + jObj.get("AMEND_CODE"));
								log.debug("AMEND_DTI_YN : " + jObj.get("AMEND_DTI_YN"));
								log.debug("BRK_COM_NAME : " + jObj.get("BRK_COM_NAME"));
								log.debug("BRK_COM_REGNO : " + jObj.get("BRK_COM_REGNO"));
								log.debug("BRK_DTI_YN : " + jObj.get("BRK_DTI_YN"));
								log.debug("BYR_COM_NAME : " + jObj.get("BYR_COM_NAME"));
								log.debug("BYR_COM_REGNO : " + jObj.get("BYR_COM_REGNO"));
								log.debug("BYR_TYPE : " + jObj.get("BYR_TYPE"));
								log.debug("CUSTOMER_COM_NAME : " + jObj.get("CUSTOMER_COM_NAME"));
								log.debug("CUSTOMER_COM_REGNO : " + jObj.get("CUSTOMER_COM_REGNO"));
								log.debug("DIRECTION : " + jObj.get("DIRECTION"));
								log.debug("DTI_STATUS : " + jObj.get("DTI_STATUS"));
								log.debug("DTI_TYPE : " + jObj.get("DTI_TYPE"));
								log.debug("DTI_WDAY : " + jObj.get("DTI_WDAY"));
								log.debug("DTT_LINK_TYPE : " + jObj.get("DTT_LINK_TYPE"));
								log.debug("CONVERSATION_ID : " + jObj.get("ETC_PCS_NO"));
								log.debug("IS_ARAP : " + jObj.get("IS_ARAP"));
								log.debug("SEQ_NO : " + jObj.get("SEQ_NO"));
								log.debug("SUP_AMT : " + jObj.get("SUP_AMT"));
								log.debug("SUP_COM_NAME : " + jObj.get("SUP_COM_NAME"));
								log.debug("SUP_COM_REGNO : " + jObj.get("SUP_COM_REGNO"));
								log.debug("TAX_DEMAND : " + jObj.get("TAX_DEMAND"));
								log.debug("EMAIL : " + jObj.get("EMAIL"));
								log.debug("DATAXML : " + jObj.get("DATAXML"));
								
								pMap.put("AMEND_CODE",jObj.get("AMEND_CODE"));
								pMap.put("AMEND_DTI_YN",jObj.get("AMEND_DTI_YN"));
								pMap.put("BRK_COM_NAME",jObj.get("BRK_COM_NAME"));
								pMap.put("BRK_COM_REGNO",jObj.get("BRK_COM_REGNO"));
								pMap.put("BRK_DTI_YN",jObj.get("BRK_DTI_YN"));
								pMap.put("BYR_COM_NAME",jObj.get("BYR_COM_NAME"));
								pMap.put("BYR_COM_REGNO",jObj.get("BYR_COM_REGNO"));
								pMap.put("BYR_TYPE",jObj.get("BYR_TYPE"));
								pMap.put("CUSTOMER_COM_NAME",jObj.get("CUSTOMER_COM_NAME"));
								pMap.put("CUSTOMER_COM_REGNO",jObj.get("CUSTOMER_COM_REGNO"));
								pMap.put("DIRECTION",jObj.get("DIRECTION"));
								pMap.put("DTI_STATUS",jObj.get("DTI_STATUS"));
								pMap.put("DTI_TYPE",jObj.get("DTI_TYPE"));
								pMap.put("DTI_WDAY",jObj.get("DTI_WDAY"));
								pMap.put("DTT_LINK_TYPE",jObj.get("DTT_LINK_TYPE"));
								pMap.put("CONVERSATION_ID",jObj.get("ETC_PCS_NO"));
								pMap.put("IS_ARAP",jObj.get("IS_ARAP"));
								pMap.put("SEQ_NO",jObj.get("SEQ_NO"));
								pMap.put("SUP_AMT",jObj.get("SUP_AMT"));
								pMap.put("SUP_COM_NAME",jObj.get("SUP_COM_NAME"));
								pMap.put("SUP_COM_REGNO",jObj.get("SUP_COM_REGNO"));
								pMap.put("TAX_DEMAND",jObj.get("TAX_DEMAND"));
								pMap.put("EMAIL",jObj.get("EMAIL"));
								pMap.put("DATAXML",jObj.get("DATAXML"));
								
								XPath xpath = XPathFactory.newInstance().newXPath();
					    		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
					    		DocumentBuilder builder = dbf.newDocumentBuilder();
					    		
					    		
					    		Document rtnDoc	= null; 
					    		
					    		try {
					    			if ( !"".equals((String)jObj.get("DATAXML")) && (String)jObj.get("DATAXML") != null ) {
							    		rtnDoc = builder.parse( new ByteArrayInputStream(((String)jObj.get("DATAXML")).getBytes("utf-8")));	
					    			}	
								} catch (Exception e) {
									log.error("DATAXML[" + (String)jObj.get("DATAXML") + "]");
									log.error("Document Build Error : " + CommonUtil.printStackTraceToString(e));
								}
					    		
					    		if (rtnDoc != null ) {
						    		String DescriptionText = (String)xpath.evaluate("/TaxInvoice/TaxInvoiceDocument/DescriptionText", rtnDoc, XPathConstants.STRING);
						    		String IssueID = (String)xpath.evaluate("/TaxInvoice/TaxInvoiceDocument/IssueID", rtnDoc, XPathConstants.STRING);
						    		String IssueDate = (String)xpath.evaluate("/TaxInvoice/TaxInvoiceDocument/IssueDateTime", rtnDoc, XPathConstants.STRING);
						    		String TaxTotalAmount = (String)xpath.evaluate("/TaxInvoice/TaxInvoiceTradeSettlement/SpecifiedMonetarySummation/TaxTotalAmount", rtnDoc, XPathConstants.STRING);
						    		String GrandTotalAmount = (String)xpath.evaluate("/TaxInvoice/TaxInvoiceTradeSettlement/SpecifiedMonetarySummation/GrandTotalAmount", rtnDoc, XPathConstants.STRING);
						    		String ItemDescriptionText = (String)xpath.evaluate("/TaxInvoice/TaxInvoiceTradeLineItem/DescriptionText", rtnDoc, XPathConstants.STRING);
						    		
						    		log.debug("DescriptionText : " + DescriptionText);
						    		log.debug("IssueID : " + IssueID);
						    		log.debug("IssueDate : " + IssueDate);
						    		
						    		pMap.put("DESCRIPTION_TEXT", DescriptionText);
						    		pMap.put("ITEM_DESCRIPTION_TEXT", ItemDescriptionText);
						    		pMap.put("ISSUE_ID", IssueID);
						    		pMap.put("ISSUE_DATE", IssueDate);
						    		pMap.put("TAX_AMT", TaxTotalAmount);
						    		pMap.put("TOT_AMT", GrandTotalAmount);
									
									List<Map<String, String>> chkRtn = dao.checkMyListInfo(pMap);
									
									log.debug("CHK_CNT : " + chkRtn.get(0).get("CHK_CNT"));
									
									if (chkRtn.size() > 0 && "0".equals(chkRtn.get(0).get("CHK_CNT"))) {
										
										List<Map<String, String>> statusCnt = dao.selectDtiStatusInfoCount(pMap);
										log.debug("DTI_CNT : " + chkRtn.get(0).get("STATUS_CNT"));
										
										if (statusCnt.size() > 0 && "0".equals(statusCnt.get(0).get("STATUS_CNT"))) {
											dao.insertTaxBillDtiStatusInfo(pMap);
										}
										
										dao.insertTaxBillMyListInfo(pMap);	
									} else {
										dao.updateTaxBillMyListInfo(pMap);
									}
					    		}
							}
						}
						else {
							log.info("데이터가 존재하지 않습니다. SENDCOMREGNO : " + tMap.get("SENDCOMREGNO") +" / SEARCHCOMREGNO : "+tMap.get("SEARCHCOMREGNO"));
						}
					}
					else{
						log.error((String)jsonResponse.get("ResultMessage"));
					}
				} catch (Exception e) {
					log.error(this.getClass().getName() + " Json Parsing Error : " + CommonUtil.printStackTraceToString(e));
				}
			}
			
		} catch (Exception e) {
			log.error("TaxBillMyListService Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
	}
}