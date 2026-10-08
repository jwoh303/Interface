package com.kep.exchangerate.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.ByteBuffer;
import java.security.AlgorithmParameters;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.IvParameterSpec;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.exchangerate.dao.ExchangeRateDao;
import com.kep.exchangerate.dao.ExchangeRateDaoImpl;

import sun.security.krb5.EncryptedData;

public class ExchangeRateServiceImpl implements ExchangeRateService {

	private Logger log	= Logger.getLogger( this.getClass() );
	
	@Override
	public void executeBatch() {
		ExchangeRateDao dao = new ExchangeRateDaoImpl();
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		
		
		String tokenApiURL = "https://api.hanabank.com:443/onegw/hbk/api/oauth/oauth/token";
		String apiURL = "https://api.hanabank.com:443/onegw/hbk/api/hbk-service/v1/exchangeRate";
		String bearerToken = "";
		String access_token = "";
		String authorization = "";
	    String appKey = "663a03a47b8d4cd1a406c07811157c4e";
        String clientId     = "87beb588-1f5f-4b39-bf14-75954b9a0842";
        String clientSecret = "c1ad47b3e81eedae4013c0f7b98fc161";
        String encKey       = "@@koreab2bR221123002";
        String entrCd       = "KOR9780441";
        encKey = encKey + entrCd + "@@";
      
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
 		Map<String, String> bMap = new HashMap<String, String>();
 		bMap.put("PGM_ID", this.getClass().getName());
 		
 		//Acces_Token, bearerToken 조회
 		try {
 			 log.info("ExchangeRateService Start!");
 			 Date currentDate = new Date();
 			 long unixTime = currentDate.getTime() / 1000;
 			 bMap.put("JOB_SDATE", dFormat.format(currentDate));
			 
 			 authorization = clientId + ":" + clientSecret + ":" + unixTime; 
             authorization = "Basic " + encrypt(encKey, authorization);
             access_token = getAccesTokenAPI(authorization, entrCd, tokenApiURL); 
             String[] decToken = decrypt(encKey, access_token).split(":"); 
             access_token = decToken[0];
			
             Date currentDate2 = new Date();
             unixTime = currentDate2.getTime() / 1000;
             authorization = access_token + ":" + unixTime + ":" + clientId;
             bearerToken ="bearer " + encrypt(encKey, authorization);
             
		} catch (Exception e) {
			 e.printStackTrace();
		}
 		
 		
 		//환율조회 API
 		try {
 			log.info("ExchangeRate API start ~~~~ ");	
 			URL url = new URL(apiURL);
			HttpURLConnection con = (HttpURLConnection)url.openConnection();
			con.setRequestMethod("POST");
	        con.setConnectTimeout(5000); 
	        con.setReadTimeout(5000); 
	        con.setDoOutput(true); 
	        con.setDoInput(true); 
	        con.setRequestProperty("Accept", "application/json");
	        con.setRequestProperty("Content-Type","application/json;charset=UTF-8");
	        con.setRequestProperty("Authorization",bearerToken); 
	        con.setRequestProperty("ENTR_CD",entrCd);
	        con.setRequestProperty("APP_KEY",appKey);
	        con.setRequestProperty("ENC_NEW","Y");

	      
	        List<Map<String, String>> curList = dao.getCurrencyCodeList(); 
	        
	        Map<String, String> dataHeaderMap =  new HashMap<String, String>();
	        dataHeaderMap.put("ENTR_CD", entrCd);
	        dataHeaderMap.put("CNTY_CD", "KR");
	        dataHeaderMap.put("CLNT_IP_ADDR", "13.125.195.196");
	        Map<String, String> dataBodyMap =  new HashMap<String, String>();
  		    if(curList.size() == 1) {
  		    	dataBodyMap.put("curCd", curList.get(0).get("EXP_CUR"));  	
  		    }else {
  		    	dataBodyMap.put("curCd", "");   	
  			}
  		    dataBodyMap.put("notiDiv", "0");
  		    dataBodyMap.put("notiCnt", "");
  		    
  		    JSONObject jsonObj = new JSONObject();
	        
	        jsonObj.put("dataHeader", dataHeaderMap); 
	        jsonObj.put("dataBody", dataBodyMap); 
	        
	        OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
	        wr.write(jsonObj.toString());
	        wr.flush();

	        StringBuilder sb = new StringBuilder();
	        if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
        	    log.info("Exchange API HttpURLConnection : HTTP_OK !!!");	
        	    BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
	            String line;
	            while ((line = br.readLine()) != null) {
	                sb.append(line).append("\n");
	            }
	            br.close();
	            JSONParser jsonParser = new JSONParser();   
	            JSONObject jsonResponse = (JSONObject)jsonParser.parse(sb.toString());
	            JSONObject jsonResultDataSet = (JSONObject) jsonResponse.get("dataBody");
				JSONArray jsonArray = (JSONArray) jsonResultDataSet.get("notiCurCdCnt");
	            
				log.info("api jsonResponse" + jsonResponse.toString());
				for(int i = 0; i < jsonArray.size(); i++){
					JSONObject getObj = (JSONObject) jsonArray.get(i);
					
					String cashSelRate = (String)getObj.get("cashSelRate");
					String cashBuyRate = (String)getObj.get("cashBuyRate");
					String ttSelRate = (String)getObj.get("ttSelRate");
					String ttBuyRate = (String)getObj.get("ttBuyRate");
					String tradeStanRate = (String)getObj.get("tradeStanRate");
					
					Map<String, String> pMap = new HashMap<String, String>();
					pMap.put("EXP_CUR", (String)getObj.get("curCd")); 
					pMap.put("EXP_BUY_PRICE",cashSelRate.substring(2,6)+"."+ cashSelRate.substring(6,cashSelRate.length())); 
					pMap.put("EXP_SEL_PRICE", cashBuyRate.substring(2,6)+"."+ cashBuyRate.substring(6,cashBuyRate.length()));
					pMap.put("EXP_TTS_PRICE",ttSelRate.substring(2,6)+"."+ ttSelRate.substring(6,ttSelRate.length()));
					pMap.put("EXP_TTB_PRICE", ttBuyRate.substring(2,6)+"."+ ttBuyRate.substring(6,ttBuyRate.length())); 
					pMap.put("STD_RATE", tradeStanRate.substring(2,6)+"."+ tradeStanRate.substring(6,tradeStanRate.length()));
					dao.saveExchangeRateInfo(pMap);
				}
				
		    	//메일 보내는 로직
				for(Map<String, String> iMap : curList) {
	        		List<Map<String, Object>> chkList = dao.getCurrencyInfoList(iMap);
	        		
	        		for( Map<String, Object> jMap : chkList ) {
	        			String WORK_FLAG = String.valueOf(jMap.get("WORK_FLAG"));
	        			
	        			if ("Y".equals(WORK_FLAG)) {
	        				// 헤더 환율 변경 안함. SR로 처리.
	        				// dao.saveExchangeRateHD(jMap);
	        				
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
	          //  System.out.println(con.getResponseMessage());
	        	log.info("Exchange API HttpURLConnection : ERROR !!!" + con.getResponseMessage());	
	        }
		} catch (Exception e) {
			e.printStackTrace();
			log.error("execute exchangeRate Error : " + e.getMessage());
		} finally {
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
			log.info("ExchangeRateService End !!!");
		}
	}


	//AccesToken 발급 API
	public String getAccesTokenAPI(String authorization, String entrCd, String tokenApiURL) {
		log.info("getAccesTokenAPI start !!!");
		log.info("getAccesTokenAPI tokenApiURL !!!" + tokenApiURL);
		
		String returnData = "";
		HttpURLConnection httpUrlConn = null;
		BufferedReader	postRes	= null;
		String	resultData	= null;
		StringBuffer resultBuffer = new StringBuffer(); 
		URL	url	= null;
		
		try {
			url	= new URL(tokenApiURL);
			httpUrlConn = (HttpURLConnection)url.openConnection();

			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded"); 
			httpUrlConn.setRequestProperty("ENC_NEW", "Y");
			httpUrlConn.setRequestProperty("ENTR_CD", entrCd); 
			httpUrlConn.setRequestProperty("Authorization", authorization); 
			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true);
			httpUrlConn.setConnectTimeout(1000 * 60);
			

			String sendData = "grant_type=client_credentials"; 
			OutputStream os = httpUrlConn.getOutputStream(); 
			os.write(sendData.getBytes());
			os.flush();
			os.close();

			postRes = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				while ((resultData = postRes.readLine()) != null) {
					resultBuffer.append(resultData);
				}
		        JSONParser jsonParser = new JSONParser();   
	            JSONObject jsonResponse = (JSONObject)jsonParser.parse(resultBuffer.toString());
	            JSONObject jsonResultDataSet = (JSONObject) jsonResponse.get("dataBody");
	            returnData = (String) jsonResultDataSet.get("access_token");
	            
		} catch (Exception e) {
			e.printStackTrace();
			log.error("execute Error : " + e.getMessage());
		}
		log.info("getAccesTokenAPI end return !!!" + resultBuffer.toString());
		return returnData;
	}
	

	//암호화
	public String encrypt(String key, String msg) {
		log.info("encrypt start !!!");
		byte[] bEncrypt = null;
		
		try {
            SecureRandom random = new SecureRandom();
            byte bytes[] = new byte[20];
            random.nextBytes(bytes);
            byte[] saltBytes = bytes;

            SecretKeySpec secret = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
			
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, secret);
            AlgorithmParameters params = cipher.getParameters();

            byte[] ivBytes = params.getParameterSpec(IvParameterSpec.class).getIV();
			
            byte[] encByte = cipher.doFinal(msg.getBytes("UTF-8"));
            bEncrypt = new byte[saltBytes.length + ivBytes.length + encByte.length];
            System.arraycopy(saltBytes, 0, bEncrypt, 0, saltBytes.length);
            System.arraycopy(ivBytes, 0, bEncrypt, saltBytes.length, ivBytes.length);
            System.arraycopy(encByte, 0, bEncrypt, saltBytes.length + ivBytes.length, encByte.length);

		} catch (Exception e) {
			e.printStackTrace();
		}
		log.info("encrypt end !!!");
		return Base64.getEncoder().encodeToString(bEncrypt);
	}
	
	
	//복호화
	public String decrypt(String key, String msg) {
		log.info("decrypt start !!!");
		byte[] bDecrypt = null; 
		
		try {
			Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
			ByteBuffer buffer = ByteBuffer.wrap(Base64.getDecoder().decode(msg));
			 
			byte[] saltBytes = new byte[20];
			buffer.get(saltBytes, 0, saltBytes.length);

			byte[] ivBytes = new byte[cipher.getBlockSize()];
			buffer.get(ivBytes, 0, ivBytes.length);
			byte[] encryptedTextBytes = new byte[buffer.capacity() - saltBytes.length - ivBytes.length]; 
			buffer.get(encryptedTextBytes);

			SecretKeySpec secret = new SecretKeySpec(key.getBytes("UTF-8"), "AES");
			cipher.init(Cipher.DECRYPT_MODE, secret, new IvParameterSpec(ivBytes));
			bDecrypt = cipher.doFinal(encryptedTextBytes);

		} catch (Exception e) { 
			e.printStackTrace();
		}
		log.info("decrypt end !!!");
		return new String(bDecrypt);
	}

}