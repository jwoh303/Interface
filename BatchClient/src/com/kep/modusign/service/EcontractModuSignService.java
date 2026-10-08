package com.kep.modusign.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.modusign.dao.EcontractModuSignDao;

public class EcontractModuSignService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	EcontractModuSignDao dao = new EcontractModuSignDao();

	public void sendEcont() {
		/**
		 * 데이터 전송대상 확인
		 * 상세 데이터 조회
		 * 데이터 세팅
		 * 전송 및 결과 확인
		 */
		Map<String, String> pMap = new HashMap<String, String>();
		
		try {
			List<Map<String,String>> tList = dao.selectEcontSendList();
			/**
			 * SUPPLIER, EC_USER_EMAIL, EC_USER_NAME, TITLE, AGENT_NAME, AGENT_IRS_NO, TEMPLATE_ID, ROLE
			 */
			
			if (tList.size() > 0) {
				for (Map<String, String> iMap : tList) {

					JSONObject body = makeContBody(iMap);
					
					log.debug("body:"+body.toString());
					
					try {
						String response = "";
						String urlPath = CommonProperty.getModusignApiUrl() + "/request-with-template";

						URL url = new URL(urlPath);
						HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
						
						con.setRequestMethod("POST");
						con.setRequestProperty("Accept", "application/json");
						con.setRequestProperty("Content-Type", "application/json");
						con.setRequestProperty("Authorization", CommonProperty.getModusignAuthorization());
						con.setDoOutput(true);
						
						OutputStream os = con.getOutputStream();
						os.write(body.toString().getBytes("utf-8"));
						os.flush();
						os.close();
						
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						StringBuffer sb = new StringBuffer();
						String inputline;
						
						while((inputline = br.readLine()) != null) {
							sb.append(inputline);
						}
						br.close();
						
						response = sb.toString();
						
						JSONParser jsonParser = new JSONParser();
						JSONObject jsonResponse = (JSONObject)jsonParser.parse(response.toString());
						
						//결과값 수신
			    		int rc = con.getResponseCode();
			    		/**
			    		 * 후처리 로직 구성.
			    		 */

			    		if ( 201 == rc ) {
			    			iMap.put("RESULT_FLAG", "Y");
			    			iMap.put("RESULT_MSG", "SUCCESS");
			    			iMap.put("EC_DOC_ID", (String)jsonResponse.get("id"));
			    		} else {
			    			iMap.put("RESULT_FLAG", "E");
			    			iMap.put("RESULT_MSG", "Econt regist Error.");
			    		}
					} catch (Exception e) {
						log.error("계약생성통신오류:" + CommonUtil.printStackTraceToString(e));
						iMap.put("RESULT_FLAG", "E");
						iMap.put("RESULT_MSG", e.getMessage());
					}
					
					log.debug("iMap:"+iMap);
					
		    		dao.updateEcontResult(iMap);
				}
			}
		} catch (Exception e) {
			log.error("계약생성실행오류:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	public void chkEcontStatus() {
		/*
		 * 전자계약서 상태가 A,B 인 경우만 상태를 확인한다.
		 */
		try {
			List<Map<String, String>> elist = dao.selectEcontStatusList();
			if (elist.size()>0) {
				for( Map<String, String> iMap : elist ) {
					String response = "";
					String urlPath = CommonProperty.getModusignApiUrl() + "/" + iMap.get("EC_DOC_ID");

					try {

						URL url = new URL(urlPath);
						HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
						
						con.setRequestMethod("GET");
						con.setRequestProperty("Accept", "application/json");
						con.setRequestProperty("Authorization", CommonProperty.getModusignAuthorization());
						
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						StringBuffer sb = new StringBuffer();
						String inputline;
						
						while((inputline = br.readLine()) != null) {
							sb.append(inputline);
						}
						br.close();
						
						response = sb.toString();
						
						log.debug("RESPONSE:"+response);
						
						JSONParser jsonParser = new JSONParser();
						JSONObject jsonResponse = (JSONObject)jsonParser.parse(response);
						JSONObject abort = (JSONObject) jsonResponse.get("abort");
						//결과값 수신
			    		int rc = con.getResponseCode();
			    		if(rc==200){
							String id = (String)jsonResponse.get("id");
							String status = (String)jsonResponse.get("status");
							String type = "";
							String E_CONTRACT_TYPE = "";
							
							if (abort != null) {
								type = (String)abort.get("type");
							}
							
							log.debug("id=============================== {}" + id);
							log.debug("status=============================== {}" + status);
							log.debug("type=============================== {}" + type);
							
							if ( "COMPLETED".equals(status) ) {
								E_CONTRACT_TYPE = "F";
							} else if ( "ABORTED".equals(status) ) {
								if ("REQUEST_CANCELLATION".equals(type)) {
									E_CONTRACT_TYPE = "E";
								} else if ("REJECTION".equals(type)) {
									E_CONTRACT_TYPE = "C";
								}
							} else if ("ON_GOING".equals(status)) {
								E_CONTRACT_TYPE = "A";
							}
							iMap.put("E_CONTRACT_TYPE",E_CONTRACT_TYPE);
							log.debug("iMap:" + iMap);
							dao.updateEcontStatus(iMap);
						}else {
							log.info("rc else=============================== {}" + rc);
							log.info("ResultCode else=============================== {}" + (String)jsonResponse.get("ResultCode"));
							log.info("jsonResponse else=============================== {}" + jsonResponse);
						}	
					} catch (Exception e) {
						log.error("상태조회통신오류:" + CommonUtil.printStackTraceToString(e));
					}				
				}
			}
		} catch (Exception e) {
			log.error("상태조회실행오류:" + CommonUtil.printStackTraceToString(e));
		}
	}
	
	@SuppressWarnings("unchecked")
	public JSONObject makeContBody(Map<String, String> pMap) throws Exception {
		/**
		 * 문서구조
		 * body
		 *  - templateId	(  기본계약서 or 기본&물류계약서 )
		 *  - document
		 *  	- title		(  기본계약서 or 기본&물류계약서 )
		 *  	- requesterInputMappings (계약서 항목 정보)	(  기본계약서 or 기본&물류계약서 )	==> Loop로 코드 단순화 필요.
		 *  	- participantMappings (계약자 정보)
		 *   		> exclued
		 *   		> signingDuration
		 *   		> locale
		 *   		> role
		 *   		> name
		 *   		> signingMethod
		 *     			> type, value
		 *   		> verification
		 *     			> dCert
		 *     				> name, bizNumber
		 */
		Map<String, String> econtInfo = dao.selectEcontInfo(pMap);

		JSONObject body	= new JSONObject();
		JSONObject document = new JSONObject();
		
		JSONArray participantMappings = new JSONArray();
		JSONObject participantItem = new JSONObject();
		JSONObject signingMethod = new JSONObject();
		signingMethod.put("type", "EMAIL");
		signingMethod.put("value", pMap.get("EC_USER_EMAIL"));
		JSONObject dCert = new JSONObject();
		dCert.put("name", pMap.get("AGENT_NAME"));
		if ( "2".equals(CommonProperty.getDB_CONN()) ) {
			dCert.put("bizNumber", pMap.get("AGENT_IRS_NO").replaceAll("-", ""));	//	운영시...	
		} else {
			dCert.put("bizNumber", "1078185880");	//	개발시...	
		}
		JSONObject verification = new JSONObject();
		verification.put("dCert", dCert);
		
		participantItem.put("excluded", false);
		participantItem.put("signingMethod", signingMethod);
		participantItem.put("signingDuration", 20160);
		participantItem.put("verification", verification);
		participantItem.put("locale", "ko");
		participantItem.put("role", pMap.get("ROLE"));
		participantItem.put("name", pMap.get("EC_USER_NAME"));
		
		participantMappings.add(participantItem);
		
		JSONArray requesterInputMappings = convertMapToJsonArray(econtInfo);
		
		// document 구성
		document.put("participantMappings", participantMappings);
		document.put("requesterInputMappings", requesterInputMappings);
		document.put("title", pMap.get("TITLE"));
		
		// body 구성
		body.put("templateId", pMap.get("TEMPLATE_ID").toString());
		body.put("document", document);

		return body;
	}
	
	@SuppressWarnings("unchecked")
	public JSONArray convertMapToJsonArray(Map<String, String> pMap) {
		
		JSONArray arr = new JSONArray();
		Iterator<String> keys = pMap.keySet().iterator();
		
		while(keys.hasNext()) {
			String dataLabel = keys.next();
			String value = pMap.get(dataLabel);
			
			if ( !"".equals(value) && value != null ) {
				JSONObject label = new JSONObject();
				label.put("dataLabel", dataLabel);
				label.put("value", value);
				arr.add(label);
			}
		}
		
		return arr;
	}
}