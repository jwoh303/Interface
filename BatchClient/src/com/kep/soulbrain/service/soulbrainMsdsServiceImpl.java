package com.kep.soulbrain.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.cert.X509Certificate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.soulbrain.dao.soulbrainMsdsDao;
import com.kep.soulbrain.dao.soulbrainMsdsDaoImpl;



public class soulbrainMsdsServiceImpl implements soulbrainMsdsService {

	private Logger log = Logger.getLogger(this.getClass());
	
	@Override
	public void execute() throws Exception {
		String send_url = "https://wish-p.soulbrain.co.kr/common/getMroData.do";
		
		Map<String, String> resultData = new HashMap<String, String>();
		soulbrainMsdsDao dao = new soulbrainMsdsDaoImpl(); 
		
		try {
			List<Map<String,String>> listMap = dao.selectTargetList();
			if (listMap != null && listMap.size() > 0) {
				for (int i = 0; i < listMap.size(); i++) {
					Map<String, String> resultMap = new HashMap<String, String>();
					String resultFlag ="E";
					String resultMsg ="";
					//SSL 인증서 무시
					TrustManager[] trustAllCerts = new TrustManager[] { 
							new X509TrustManager() {
								public X509Certificate[] getAcceptedIssuers() {return null;}
								public void checkClientTrusted(X509Certificate[] certs, String authType) {}
								public void checkServerTrusted(X509Certificate[] certs, String authType) {}
							} 
					};
					SSLContext sc = SSLContext.getInstance("SSL");
			    	sc.init(null, trustAllCerts, new java.security.SecureRandom());
					HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
					HostnameVerifier allHostsValid = new HostnameVerifier() {
						public boolean verify(String hostname, SSLSession session){
							return true;
						}
					};
					
					URL url = new URL(send_url);
					HttpURLConnection con = (HttpURLConnection)url.openConnection();
					
					con.setRequestMethod("POST");
			        con.setConnectTimeout(5000); 
			        con.setReadTimeout(5000); 
			        con.setDoOutput(true); 
			        con.setDoInput(true); 
			        con.setRequestProperty("Accept", "application/json");
			        con.setRequestProperty("Content-Type","application/json;charset=UTF-8");
				
			        //데이터 조합
			        String keyId = listMap.get(i).get("BUYER") + "/" + listMap.get(i).get("QUOTATION_NO") + "/" +  listMap.get(i).get("QUOTATION_SEQ");
			        
					JSONObject jsonObj = new JSONObject();
					jsonObj.put("KEY_ID", keyId);
					jsonObj.put("COMP_CD", listMap.get(i).get("COMP_CD"));
					jsonObj.put("PLNT_CD", "1000");
					jsonObj.put("USER_NM", listMap.get(i).get("BTOA_USER_NAME"));
					jsonObj.put("DEPT_NM", listMap.get(i).get("BTOA_USER_DEPT"));
					jsonObj.put("RQST_DATE", listMap.get(i).get("BTOA_DATE"));
					jsonObj.put("MSDS_NM", listMap.get(i).get("MSDS_NM"));
					jsonObj.put("MSDS_MFR",listMap.get(i).get("MAKER_NAME"));
					jsonObj.put("MSDS_FILE", listMap.get(i).get("MSDS_URL"));
					resultData.put("CONTENTS", keyId);
					
					
			        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
			        wr.write(jsonObj.toString());
			        wr.flush();

					StringBuilder sb = new StringBuilder();
					if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						String line;
						while ((line = br.readLine()) != null) {
							sb.append(line).append("\n");
						}
						br.close();
						
						JSONParser jsonParser = new JSONParser();   
						Object jsonResponse = jsonParser.parse(sb.toString());
						JSONArray jsonArray = (JSONArray)jsonResponse;
						JSONObject jsonTable = (JSONObject)jsonArray.get(0);
						resultFlag = jsonTable.get("STATUS_CD").toString();
					
						resultMap.put("QUOTATION_NO", listMap.get(i).get("QUOTATION_NO")); 
						resultMap.put("QUOTATION_SEQ", listMap.get(i).get("QUOTATION_SEQ")); 
						resultMap.put("BUYER", listMap.get(i).get("BUYER")); 
						
						if("S".equals(resultFlag)) {
							resultMap.put("IF_FLAG", "Y"); 
							dao.updateMsdsResult(resultMap);
						}else {
							resultMap.put("IF_FLAG", "E"); 
							resultMsg = jsonTable.get("MSG").toString();
							resultData.put("INTERFACE_ID", "soulbrainMsdsServiceImpl");
				        	resultData.put("CONTENTS", keyId);
				        	resultData.put("FLAG", resultFlag);
				        	resultData.put("ERROR_MSG", resultMsg);
				        	dao.saveErrLog(resultData);
							log.info("soulbrainMsdsServiceImpl :return ERROR !!!");	
						}
						dao.updateReSendList(resultMap);
					}
				}
			}
		} catch (Exception e) {
				try {
					resultData.put("INTERFACE_ID", "soulbrainMsdsServiceImpl");
					resultData.put("ERROR_MSG", e.toString());
					resultData.put("FLAG", "E");
					dao.saveErrLog(resultData);
				} catch (Exception e2) {
					e2.printStackTrace();
					log.error("execute Error e2: " + e2.getMessage());
				}
			e.printStackTrace();
			log.error("execute Error : " + e.getMessage());
		}
	}

}
