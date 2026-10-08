package com.kep.obBeer.service;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPatch;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.obBeer.dao.ObBeerPoDao;
import com.kep.obBeer.dao.ObBeerPoDaoImpl;


public class ObBeerPoStatusServiceImpl implements ObBeerPoStatusService{

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void execute() throws Exception {

		ObBeerPoDao obDao = new ObBeerPoDaoImpl();
		
		String tokenApiURL = "https://api.bees-kconnect.com/eai/budweiser/eds/api/v1/token_0002";
		String patchURL = "https://api.bees-kconnect.com/eai/budweiser/api/v1/orders/order_ksta_0001";
		
		
		List<Map<String,String>> map = obDao.selectPoStatusTargetList();
		int size = map.size();
		
		if (size > 0) {
			Map<String, String> tokenMap = getAccesTokenAPI(tokenApiURL);
			for (Map<String, String> iMap : map) {
				String resultFlag = "Y";
				BufferedReader in = null;
				CloseableHttpClient httpClient = HttpClients.createDefault(); 
				
				try {
					//헤드 날짜
					Date today = new Date();
					Locale Locale = new Locale("KOREAN" , "KOREA");
					String pattern = "yyyyMMddHHmmss";
					SimpleDateFormat formatter = new SimpleDateFormat(pattern, Locale);
					String currentdate = formatter.format(today);
					
					//대상 리스트
					JSONObject payload	= new JSONObject();
					JSONArray targetList = new JSONArray();
					JSONObject target	= new JSONObject();
					JSONObject delivery	= new JSONObject();
					JSONObject cancellation	= new JSONObject();
					target.put("orderNumber", iMap.get("KEY_1"));
					
					//CONFIRMED or DELIVERED
					if("PO".equals(iMap.get("KEY_3"))){
						target.put("status", "CONFIRMED");
					}else {
						target.put("status", "DELIVERED");
					}
					delivery.put("date", iMap.get("KEY_4"));
					
					target.put("delivery", delivery);
					targetList.add(target);
					payload.put("order", targetList);
					
					//기본 값
					JSONObject json1 = new JSONObject();
					json1.put("entity", "ORDERS");
					json1.put("version", "v2");
					json1.put("payload", payload);
					
					HttpPatch httpPatch = new HttpPatch(patchURL);
					
					httpPatch.setHeader("Content-Type","application/json");
					httpPatch.setHeader("Authorization","Bearer " + tokenMap.get("token"));
					httpPatch.setHeader("Request-Trace-Id", "KEDM00005_ORDER_KSTA_0001_" + currentdate);
					httpPatch.setHeader("country","KR");
					httpPatch.setHeader("Time-Zone", "Asia/Seoul");
					
					HttpEntity enJson = new StringEntity(json1.toString(),ContentType.APPLICATION_JSON);
					httpPatch.setEntity(enJson);
					CloseableHttpResponse response = httpClient.execute(httpPatch); 
					
					InputStream inputStream = (InputStream)response.getEntity().getContent(); 
					
					String inputLine = null;
					in = new BufferedReader(new InputStreamReader(inputStream, "utf-8"));
					StringBuilder result = new StringBuilder();
					while ((inputLine = in.readLine()) != null) {
						result.append(inputLine).append("\n");
					}
					response.close();
					
					String resultCode = result.toString();
					JSONParser parser = new JSONParser();
					Object obj = parser.parse(resultCode.toString());
					JSONObject jsonObj = (JSONObject) obj;
					String statusCode = (String)jsonObj.get("statusCode");
					
					if(!"200".equals(statusCode)) {
						resultFlag = "E";
					}
					
				} catch (Exception e) {
					resultFlag = "E";
					e.printStackTrace();
					log.error("ObBeerPoStatusServiceImpl execute Error" + e.getMessage());
				}finally {
					in.close();
					httpClient.close();
					iMap.put("FLAG", resultFlag);
					obDao.updateObAppSubmitResult(iMap);
				}
			}
		}
	}
	
	private Map<String, String> getAccesTokenAPI(String tokenApiURL) {
		Map<String, String> returnData = new HashMap<String, String>();
		HttpURLConnection httpUrlConn = null;
		BufferedReader postRes = null;
		String resultData = null;
		URL url = null;
		
		try {
			url = new URL(tokenApiURL);
			httpUrlConn = (HttpURLConnection) url.openConnection();

			Date today = new Date();
			Locale Locale = new Locale("KOREAN" , "KOREA");
			String pattern = "yyyyMMddHHmmss";
			SimpleDateFormat formatter = new SimpleDateFormat(pattern, Locale);
			String currentdate = formatter.format(today);
			
			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type", "application/json");
			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true);
			httpUrlConn.setRequestProperty("Contry", "KR");
			httpUrlConn.setRequestProperty("Time-Zone", "Asia/Seoul");
			httpUrlConn.setRequestProperty("Request-Trace-Id", "KEP_COMMON_0001_" + currentdate);
			httpUrlConn.setConnectTimeout(1000 * 60);
			httpUrlConn.setReadTimeout(5000); 
			httpUrlConn.setUseCaches(false);
			
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("grant_type", "client_credentials");
		    jsonObj.put("client_id", "0xvduxonCCt5l8Xp5CqtdA==");
		    jsonObj.put("client_secret", "sZRLrrENgO8fniaWxByDwaWEaAtD+fIaYn1N7hScY6I=");
			
		    OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream());
	        wr.write(jsonObj.toString());
	        wr.flush();
	        wr.close();
	        
	        StringBuilder sb = new StringBuilder();
	        if (httpUrlConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
	        	BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();   
				JSONObject jsonResponse = (JSONObject)jsonParser.parse(sb.toString());
				
				JSONObject jsonObj1 = (JSONObject) jsonResponse;
				JSONObject jsonObj2 = (JSONObject) jsonObj1.get("Message");
	        	
				returnData.put("token",(String)jsonObj2.get("token"));
				httpUrlConn.disconnect();
				
	        }else {
	        	BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();   
				JSONObject jsonResponse = (JSONObject)jsonParser.parse(sb.toString());
			
				httpUrlConn.disconnect();
	        }
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ObBeerPoStatusServiceImpl Token execute Error : " + e.getMessage());
		}
		
		
		return returnData;
	}
	
}
