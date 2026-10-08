/**
 * 
 */
package com.koreab2b.mro.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author jiwon
 *
 */
public class HttpClientUtil {
	
	//HTTPS 
	@SuppressWarnings("unchecked")
	public static Map<String, Object> apiCallHttps(String method, String company, String apiUrl, Map<String,Object> data, String token) { 
		Map<String, Object> result = new HashMap<String,Object>();
		ArrayList<Map<String, Object>> resultLst = new ArrayList<Map<String, Object>>();
		ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환		
		try {	
			
	        URL url = new URL(apiUrl);
	        
	        // Https SSL인증서 무시하기
        	try {	        		
        		ignorSsl();	        		
        	} catch(Exception e) {
        		e.printStackTrace();
        	}        	


	        // HttpsURLConnection 객체 생성 및 설정
	        HttpsURLConnection conn = (HttpsURLConnection) url.openConnection();
	        conn.setRequestMethod(method);
	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setRequestProperty("Accept", "application/json");	 
	        if(token != null && !token.equals("")) {
	        	conn.setRequestProperty("Authorization", token);
	        }	        
	        
	        if("HANJIN".equals(company)) {
	        	conn.setRequestProperty("x-api-key", CommonProperty.getHanjinApiKey());     	
	        }
	        
	        conn.setDoOutput(true);
	        
	        if("POST".equals(method)) {
	        	// JSON 데이터 전송
	        	OutputStream outputStream = conn.getOutputStream();	        	
	        	outputStream.write(mapper.writeValueAsString(data).getBytes());		 
		        outputStream.flush();
		        outputStream.close();
	        }	        	        
	
	        // 응답 코드 확인
	        int responseCode = conn.getResponseCode();
	        System.out.println("##### 응답 코드 : " + responseCode);
	        
	        // 응답 데이터 읽기
	        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        String line;
	        StringBuilder response = new StringBuilder();	
	
	        while ((line = reader.readLine()) != null) {
	            response.append(line);
	        }
	
	        reader.close();
	
	        // 응답 데이터 출력
	        System.out.println("##### 응답 데이터 : " + response.toString());
	       
	        // 연결 해제
	        conn.disconnect();	            
	        
	        // 휴젤 객체로 던져줌 / 호반호텔 배열,객체로 던져줌
	        if("GET".equals(method)) {
	        	resultLst = mapper.readValue(response.toString(), ArrayList.class);
		        result.put("result",resultLst);
	        }else {
	        	result = mapper.readValue(response.toString(), Map.class);
	        }
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
		return result;
		
	}
	
	// Https SSL 인증서 무시 함수
	public static void ignorSsl() throws Exception{
		TrustManager[] trustAllCerts = new TrustManager[] { 
			new X509TrustManager() {
				public X509Certificate[] getAcceptedIssuers() {return null;}
				public void checkClientTrusted(X509Certificate[] certs, String authType) {}
				public void checkServerTrusted(X509Certificate[] certs, String authType) {}
		  } 
		};
		
		// Install the all-trusting trust manager
        try {
        	SSLContext sc = SSLContext.getInstance("SSL");
        	sc.init(null, trustAllCerts, new java.security.SecureRandom());
    		HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
    		// Create all-trusting host name verifier
    		HostnameVerifier allHostsValid = new HostnameVerifier() {
    			public boolean verify(String hostname, SSLSession session){
    				return true;
    			}
    		};

    		// Install the all-trusting host verifier
    		HttpsURLConnection.setDefaultHostnameVerifier(allHostsValid);
        }catch(Exception e) {
        	e.printStackTrace();
        }
	}
}
