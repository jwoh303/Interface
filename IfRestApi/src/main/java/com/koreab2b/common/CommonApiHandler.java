/**
 * 
 */
package com.koreab2b.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.Map;
import java.util.logging.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * @author jiwon
 * 		공통  API 핸들러
 */
public class CommonApiHandler {

private Logger log	= Logger.getLogger(this.getClass().getName());
	
	public static StringBuilder getData(String apiUrl, Map<String,Object> data) {  //, hugelvo[] data 추가 데이터 매개변수 필요
		StringBuilder result = new StringBuilder();
		ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
		
		 try {	
	            // 휴젤 접속 User, Password
	            String username = "sb-e7d35d23-d096-420f-8058-dfe136a8bddf!b1458|it-rt-is-dev!b33";
	            String password = "c98bf9db-98c0-4eeb-a6be-3ecb9483dfea$JS7G_BJvDx1Ff2ogYu5jyBQT5CvhdBaXrSJycvIEpqI=";

	            // HttpHeaders 설정
	            String authHeader = username + ":" + password;
	            byte[] authHeaderBytes = authHeader.getBytes();
	            byte[] base64AuthHeaderBytes = Base64.getEncoder().encode(authHeaderBytes);
	            String base64AuthHeader = new String(base64AuthHeaderBytes);

	            URL url = new URL(apiUrl);

	            // HttpURLConnection 객체 생성 및 설정
	            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	            conn.setRequestMethod("POST");
	            conn.setRequestProperty("Content-Type", "application/json");
	            conn.setRequestProperty("Authorization", "Basic " + base64AuthHeader);
	            conn.setDoOutput(true);

	            // JSON 데이터 전송
	            OutputStream outputStream = conn.getOutputStream();
	            outputStream.write(mapper.writeValueAsString(data).getBytes());
	            outputStream.flush();
	            outputStream.close();

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
	            System.out.println("##### 응답 데이터 : ");
	            System.out.println(response.toString());
	           
	            // 연결 해제
	            conn.disconnect();	            
	            
	            result = response;
	            
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
		 return result;
	}
}
