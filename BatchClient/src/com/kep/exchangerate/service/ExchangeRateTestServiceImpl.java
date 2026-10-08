package com.kep.exchangerate.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.exchangerate.dao.ExchangeRateDao;
import com.kep.exchangerate.dao.ExchangeRateDaoImpl;

public class ExchangeRateTestServiceImpl implements ExchangeRateTestService {

	private Logger log = Logger.getLogger(this.getClass());

	@Override
	public void executeBatch() {
		ExchangeRateDao dao = new ExchangeRateDaoImpl();

		String tokenApiURL = "https://api.hanabank.com/oauth/2.0/token";
		String exchangeURL ="https://api.hanabank.com/kebhnb/ldm/v2/inquiry/exchangeRateSync";
		String authorization = "";
		String access_token = "";
		String bearerToken = "";
		String strDate =""; 
		log.info("ExchangeRateService Start!");
		try {
			SimpleDateFormat Format = new SimpleDateFormat("yyyyMMdd");
			Calendar c1 = Calendar.getInstance();
			c1.add(Calendar.DATE, -1);
			strDate =  Format.format(c1.getTime());
			
			Map<String, String> tokenMap = getAccesTokenAPI(tokenApiURL);
			authorization = "Bearer " + tokenMap.get("access_token");
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("execute token Error  : " + e.getMessage());
		}

		
		try {
			URL url = new URL(exchangeURL);
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("POST");
	        con.setConnectTimeout(5000); 
	        con.setReadTimeout(5000); 
	        con.setDoOutput(true); 
	        con.setDoInput(true); 
	        con.setRequestProperty("Accept", "application/json");
	        con.setRequestProperty("Content-Type","application/json;charset=UTF-8");
	        log.info("authorization !!!!" + authorization);	
	        con.setRequestProperty("Authorization",authorization); 
	        con.setRequestProperty("CRYP_DV_CD","0"); 
	
	        log.info("authorization !!!!" + authorization);	
	        List<Map<String, String>> curList = dao.getCurrencyCodeList(); 
	        
	        JSONObject jsonObj = new JSONObject();
	        jsonObj.put("INQ_KIND_CD", "1");
	        jsonObj.put("INQ_STR_DT", strDate);
	        jsonObj.put("INQ_END_DT", strDate);
			if(curList.size() == 1) {
				jsonObj.put("CUR_CD", curList.get(0).get("EXP_CUR"));
			}
	        jsonObj.put("PBLD_DV_CD", "0");
	        
	        log.info("jsonResponse RESULT !!!!" +jsonObj.toString());	
	        
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
				JSONObject jsonResponse = (JSONObject)jsonParser.parse(sb.toString());
				JSONArray jsonArray = (JSONArray) jsonResponse.get("REC");
				log.info("jsonResponse object RESULT !!!!" +jsonResponse);	
				log.info("jsonResponse jsonArray RESULT !!!!" +jsonArray);	
				for(int i = 0; i < jsonArray.size(); i++){
					JSONObject getObj = (JSONObject) jsonArray.get(i);
					
					String cashSelRate = (String)getObj.get("ACMN_SLL_RT");
					String cashBuyRate = (String)getObj.get("ACMN_BUY_RT");
					String ttSelRate = (String)getObj.get("TT_SLL_RT");
					String ttBuyRate = (String)getObj.get("TT_BUY_RT");
					String tradeStanRate = (String)getObj.get("DEAL_BASC_RT");
					
					Map<String, String> pMap = new HashMap<String, String>();
					pMap.put("EXP_CUR", (String)getObj.get("CUR_CD")); 
					pMap.put("EXP_BUY_PRICE",cashSelRate.substring(2,6)+"."+ cashSelRate.substring(6,cashSelRate.length())); 
					pMap.put("EXP_SEL_PRICE", cashBuyRate.substring(2,6)+"."+ cashBuyRate.substring(6,cashBuyRate.length()));
					pMap.put("EXP_TTS_PRICE",ttSelRate.substring(2,6)+"."+ ttSelRate.substring(6,ttSelRate.length()));
					pMap.put("EXP_TTB_PRICE", ttBuyRate.substring(2,6)+"."+ ttBuyRate.substring(6,ttBuyRate.length())); 
					pMap.put("STD_RATE", tradeStanRate.substring(2,6)+"."+ tradeStanRate.substring(6,tradeStanRate.length()));
					dao.saveExchangeRateInfo2(pMap);
				}
	        	
				//메일 보내는 로직
				for(Map<String, String> iMap : curList) {
	        		List<Map<String, Object>> chkList = dao.getCurrencyInfoList(iMap);
	        		
	        		for( Map<String, Object> jMap : chkList ) {
	        			String WORK_FLAG = String.valueOf(jMap.get("WORK_FLAG"));
	        			
	        			if ("Y".equals(WORK_FLAG)) {
	        				
	        				List<Map<String, String>> mailUsers = dao.getSendMailUser(jMap);
	        				
	        				if (mailUsers.size() > 0 ) {
	            				Map<String, String> mailUser = mailUsers.get(0);

	            				// 메일 발송.
	            				String H_RECEIVE_EMAIL	= mailUser.get("EMAIL");
	            				String H_RECEIVE_NAME	= mailUser.get("USER_NAME_LOC");
	            				String H_MAIL_SUBJECT	= "["+jMap.get("COM_NAME_LOC")+"]환율 변경 알림 메일";
	            				String H_MAIL_CONTENTS	= "</br> * 고객사 : "+jMap.get("COM_NAME_LOC")+"("+jMap.get("BUYER")+")";
	            				H_MAIL_CONTENTS	= H_MAIL_CONTENTS + "</br> * 기존환율:"+jMap.get("EXP_CUR_PRICE")+"</br> * 변경환율:"+jMap.get("EXP_TTB_PRICE");

	            				jMap.put("H_RECEIVE_EMAIL"	,H_RECEIVE_EMAIL);	// H_RECEIVE_EMAIL
	            				jMap.put("H_RECEIVE_NAME"	,H_RECEIVE_NAME);	// H_RECEIVE_NAME
	            				jMap.put("H_MAIL_SUBJECT"	,H_MAIL_SUBJECT);	// H_MAIL_SUBJECT
	            				jMap.put("H_MAIL_CONTENTS"	,H_MAIL_CONTENTS);	// H_MAIL_CONTENTS

	            				dao.sendExchangeAlertMail(jMap);
	            				log.info("Exchange Alert Mail : Mail will be sent to [" +mailUser.get("USER_NAME_LOC")+ "]");
	        				} else {
	        					log.info("Exchange Alert Mail : There is no person for [" +jMap.get("BUYER")+ "] ");
	        				}
	        			}
	        		}
	        	}
				
	        }else {
	        	log.info("Exchange API HttpURLConnection : ERROR !!!" + con.getResponseMessage() );	
	        	
	        	BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();   
				JSONObject jsonResponse = (JSONObject)jsonParser.parse(sb.toString());
	        	
	        }
		} catch (Exception e) {
			e.printStackTrace();
			log.error("execute Error : " + e.getMessage());
		}
	
	}

	public Map<String, String> getAccesTokenAPI(String tokenApiURL) {
		Map<String, String> returnData = new HashMap<String, String>();
		HttpURLConnection httpUrlConn = null;
		BufferedReader postRes = null;
		String resultData = null;
		StringBuffer resultBuffer = new StringBuffer();
		URL url = null;

		try {
			url = new URL(tokenApiURL);
			httpUrlConn = (HttpURLConnection) url.openConnection();

			String sendData = "grant_type=client_credentials&client_id=KOREAEPLAT8kPjXWDa8jkQsPhOsGIBuP&client_secret=AfcTlMDgqeR6gySlgnERNMkP0PFtMud7";

			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true);
			httpUrlConn.setConnectTimeout(1000 * 60);
			httpUrlConn.setUseCaches(false);
			try (DataOutputStream os = new DataOutputStream(httpUrlConn.getOutputStream())) {
				os.write(sendData.getBytes());
				os.flush();
				os.close();
			}
			postRes = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
			while ((resultData = postRes.readLine()) != null) {
				resultBuffer.append(resultData);
			}
	        JSONParser jsonParser = new JSONParser();   
            JSONObject jsonResponse = (JSONObject)jsonParser.parse(resultBuffer.toString());
            returnData.put("access_token", (String) jsonResponse.get("access_token"));
            returnData.put("token_type", (String) jsonResponse.get("token_type"));
            
		} catch (Exception e) {
			e.printStackTrace();
			log.error("execute Error : " + e.getMessage());
		}
		log.info("getAccesTokenAPI end return !!!" + returnData);
		return returnData;
	}

}
