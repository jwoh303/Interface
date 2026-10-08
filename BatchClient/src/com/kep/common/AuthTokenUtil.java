/**
 * 
 */
package com.kep.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.delivery.dao.ParcelDao;
import com.kep.delivery.dao.ParcelDaoImpl;
import com.kep.hanssem.dao.HanssemDao;
import com.kep.hanssem.dao.HanssemDaoImpl;
import com.kep.hkInn.dao.HkInnDao;
import com.kep.hkInn.dao.HkInnDaoImpl;
import com.kep.skmw.dao.SkMwDao;
import com.kep.skmw.dao.SkMwDaoImpl;
import com.kep.skpc.dao.SkPcDao;
import com.kep.skpc.dao.SkPcDaoImpl;

/**
 * @author jiwon
 *
 */
public class AuthTokenUtil {
	private static Logger log	= Logger.getLogger(HttpClientUtil.class.getName());	
	
	@SuppressWarnings("unchecked")
	public static Map<String, Object> getNewToken(String url, String key, String secretKey) {
		
		Map<String, Object> result = new HashMap<String,Object>();		
		ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
		Map<String,Object> paramMap = new HashMap<String,Object>(); // 전송객체
		
		try {	
			
	        URL urlRslt = new URL(url);
	        // HttpsURLConnection 객체 생성 및 설정
	        HttpsURLConnection conn =  (HttpsURLConnection) urlRslt.openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setRequestProperty("Accept", "application/json");	        
	        conn.setDoOutput(true);
	        
	        paramMap.put("key", key);
	        paramMap.put("secretKey", secretKey);
	        
        	// JSON 데이터 전송
	        OutputStream outputStream = conn.getOutputStream();
	        outputStream.write(mapper.writeValueAsString(paramMap).getBytes());
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
	        
	        result = mapper.readValue(response.toString(), Map.class);
	        result.put("statusCode", responseCode);
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public static Boolean checkToken(String url, String token) {
	
		boolean result = false;		
//		ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
		
		try {	
			
	        URL urlRslt = new URL(url);
	        // HttpsURLConnection 객체 생성 및 설정
	        HttpsURLConnection conn = (HttpsURLConnection) urlRslt.openConnection();
	        conn.setRequestMethod("GET");
	        conn.setRequestProperty("Accept", "application/json");	        
	        conn.setRequestProperty("Authorization", "Bearer " + token);
	
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
	        if(responseCode == 200) {
	        	result = Boolean.parseBoolean(response.toString());
	        }
	        
	    } catch (IOException e) {
	        e.printStackTrace();
	    }
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public static String getInnToken() {
		HkInnDao hkInnDao = new HkInnDaoImpl();
		String token = "";
		Map<String, Object> tokenMap = new HashMap<String,Object>();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
		/**
		 * HK이노엔 인증토큰 발급 
		 */
		try {
            // 인증토큰 발급 호출
			boolean tokenVal = false;			
            String url = CommonProperty.getHkInnUrl() + "token";
            String key = CommonProperty.getHkInnKey();
            String secretKey = CommonProperty.getHkInnSecretKey();    
            Map<String, Object> newToken = new HashMap<String,Object>();
            List<Map<String,Object>> checkTokenLst = new ArrayList<Map<String,Object>>();
            // 기존 토큰 유효성 검사
            checkTokenLst = hkInnDao.checkTokenVal();
            if(checkTokenLst.size() > 0) {
            	tokenVal = Boolean.parseBoolean(checkTokenLst.get(0).get("TOKEN_VAL").toString());            	
            }
			if(tokenVal) {
				log.info("##### HK이노엔 인증토큰 기존 토큰 유효 : ");
				token = checkTokenLst.get(0).get("TOKEN").toString();
			}else {
				tokenMap = AuthTokenUtil.getNewToken(url, key, secretKey);
				if(tokenMap.get("statusCode").toString().equals("201")) {
	            	log.info("##### HK이노엔 인증토큰 발급 성공 : " + tokenMap.toString());
	            	tokenVal = AuthTokenUtil.checkToken(url, tokenMap.get("token").toString());
	            	if(tokenVal) {
	            		token = "Bearer "+tokenMap.get("token").toString();
	            		newToken.put("token", token);
	            		String dateStr = tokenMap.get("expireDate").toString();
	            		LocalDate date = LocalDate.parse(dateStr, formatter);
	            		LocalDate newDate = date.minusDays(7); 
	            		String expireDate = newDate.format(formatter);
		            	newToken.put("expireDate", expireDate);		            	
		            	hkInnDao.mergeHkInnToken(newToken);
	            	}else {
	            		log.info("##### HK이노엔 토큰 인증 실패 : ");
	            	}
	            }else {
	            	log.info("##### HK이노엔 인증토큰 발급 실패 : ");
	            }
			}
            
            log.info("##### HK이노엔 인증토큰 : " + token);
			
		} catch (Exception e) {
			log.error("HkInnToken Error : " + CommonUtil.printStackTraceToString(e));
		}
		return token;
	}
	
	@SuppressWarnings("unchecked")
	public static String getSkMwToken() {
		SkMwDao skMwDao = new SkMwDaoImpl();
		String token = "";
		try {
            // 인증토큰 발급 호출
            List<Map<String,Object>> tokenLst = new ArrayList<Map<String,Object>>();
            // 기존 토큰 유효성 검사
            tokenLst = skMwDao.selectSkMwToken();
            if(tokenLst.size() > 0) {
            	token = tokenLst.get(0).get("TOKEN").toString();
            }else {
            	log.info("##### SK마이크로웍스 토큰 존재 X");			
			}
            
            log.info("##### SK마이크로웍스 인증토큰 : " + token);			
			
		} catch (Exception e) {
			log.error("SkMwToken Error : " + CommonUtil.printStackTraceToString(e));
		}		
		return token;
	}

	@SuppressWarnings("unchecked")
	public static String getSkPcToken() {
		SkPcDao skPcDao = new SkPcDaoImpl();
		String token = "";
		try {
            // 인증토큰 발급 호출
            List<Map<String,Object>> tokenLst = new ArrayList<Map<String,Object>>();
            // 기존 토큰 유효성 검사
            tokenLst = skPcDao.selectSkPcToken();
            if(tokenLst.size() > 0) {
            	token = tokenLst.get(0).get("TOKEN").toString();
            }else {
            	log.info("##### SK피유코어 토큰 존재 X");			
			}
            
            log.info("##### SK피유코어 인증토큰 : " + token);			
			
		} catch (Exception e) {
			log.error("SkPcToken Error : " + CommonUtil.printStackTraceToString(e));
		}	
		return token;
	}
	
	@SuppressWarnings("unchecked")
	public static String getHanssemToken() {		
		HanssemDao hanssemDao = new HanssemDaoImpl();
		Map<String, Object> tokenMap = new HashMap<String,Object>();
		String token = "";
		String target = "";
		try {
            // 인증토큰 발급 호출
            List<Map<String,Object>> tokenLst = new ArrayList<Map<String,Object>>();
            // 기존 토큰 유효성 검사
            if("0".equals(CommonProperty.getHanssemNo())) {
            	target = "KRHANS_DEV";
            }else if("1".equals(CommonProperty.getHanssemNo())) {
            	target = "KRHANS_QA";
            }else {
            	target = "KRHANS";
            }
            tokenMap.put("target", target);
        	tokenLst = hanssemDao.selectHanssemToken(tokenMap);
        	
            if(tokenLst.size() > 0) {
            	token = tokenLst.get(0).get("TOKEN").toString();
            }else {
            	log.info("##### 한샘 토큰 존재 X");			
			}
            
            log.info("##### 한샘 인증토큰 : " + token);			
			
		} catch (Exception e) {
			log.error("HanssemToken Error : " + CommonUtil.printStackTraceToString(e));
		}	
		return token;
	}
	
	@SuppressWarnings("unchecked")
	public static String getParcelToken() {
		ParcelDao parcelDao = new ParcelDaoImpl();
		String token = "";
		try {
            // 인증토큰 발급 호출
            List<Map<String,Object>> tokenLst = new ArrayList<Map<String,Object>>();
            // 기존 토큰 유효성 검사
            tokenLst = parcelDao.selectParcelToken();
            if(tokenLst.size() > 0) {
            	token = tokenLst.get(0).get("TOKEN").toString();
            }else {
            	log.info("##### PARCEL 토큰 존재 X");			
			}
            
            log.info("##### PARCEL 인증토큰 : " + token);			
			
		} catch (Exception e) {
			log.error("ParcelToken Error : " + CommonUtil.printStackTraceToString(e));
		}	
		return token;
	}
	
	@SuppressWarnings("unchecked")
	public static String getHanjinHMAC() {
		String HMAC = "";
		Map<String, Object> result = new HashMap<String,Object>();	
		ObjectMapper mapper = new ObjectMapper(); // JSON 객체 변환
		
		try {
			String url = CommonProperty.getHanjinUrl() + "/v1/util/hmacgen";
            String key = CommonProperty.getHanjinApiKey();
            String clientId = CommonProperty.getHanjinClientId();    
            
            URL urlRslt = new URL(url);
	        // HttpsURLConnection 객체 생성 및 설정
	        HttpsURLConnection conn =  (HttpsURLConnection) urlRslt.openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/json");
	        conn.setRequestProperty("Accept", "application/json");	       
	        conn.setRequestProperty("x-api-key", key);
	        conn.setRequestProperty("client_id", clientId);	        
        	conn.setFixedLengthStreamingMode(0);
        	conn.setRequestProperty("Content-Length", "0");        	
        	conn.setDoOutput(true);
	
	        // 응답 코드 확인
	        int responseCode = conn.getResponseCode();
	        System.out.println("##### Hanjin HMACK 응답 코드 : " + responseCode);
	        
	        // 응답 데이터 읽기
	        BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        String line;
	        StringBuilder response = new StringBuilder();	
	
	        while ((line = reader.readLine()) != null) {
	            response.append(line);
	        }
	
	        reader.close();
	
	        // 응답 데이터 출력
	        System.out.println("##### Hanjin HMACK 응답 데이터 : ");
	        System.out.println(response.toString());
	       
	        // 연결 해제
	        conn.disconnect();	            
	        
	        result = mapper.readValue(response.toString(), Map.class);
	        if(result != null) {
	        	HMAC = (String) result.get("Authorization");
	        }
	        
            log.info("##### Hanjin HMAC SUCCESS ");			
			
		} catch (Exception e) {
			log.error("Hanjin HMAC Error : " + CommonUtil.printStackTraceToString(e));
		}	
		return HMAC;
	}
}
