package com.kep.obBeer.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.obBeer.dao.ObBeerPoDao;
import com.kep.obBeer.dao.ObBeerPoDaoImpl;

public class ObBeerIvServiceImpl implements ObBeerIvService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void execute() throws Exception {
		ObBeerPoDao obDao = new ObBeerPoDaoImpl();
		
		String tokenApiURL = "https://api.bees-kconnect.com/eai/budweiser/eds/api/v1/token_0002";
		String invoiceURL = "https://api.bees-kconnect.com/eai/budweiser/eds/api/v1/orders/invoice_ksta_0003";
		
		
		List<Map<String,String>> map = obDao.selectIvSendTargetList();
		
		if (map != null && map.size() > 0) {
			//토큰 받기
			Map<String, String> tokenMap = getAccesTokenAPI(tokenApiURL);
			String authorization = "Bearer " + tokenMap.get("token").trim();
			
			for (Map<String, String> iMap : map) {
				URL url = null;
				url = new URL(invoiceURL);
				HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
				String resultFlag = "Y";
				
				try {
					//제이슨 날짜
					Date today = new Date();
					Locale Locale = new Locale("KOREAN" , "KOREA");
					String pattern2 = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'";
					SimpleDateFormat formatter2 = new SimpleDateFormat(pattern2, Locale);
					String currentdate2 = formatter2.format(today);
					
					String invDate = iMap.get("INV_DATE");
					SimpleDateFormat formatter3 = new SimpleDateFormat("yyyyMMdd");
					Date formatDate = formatter3.parse(invDate);
					String currentdate3 = formatter2.format(formatDate);
					
					//대상 리스트
					JSONObject target	= new JSONObject();
					JSONArray payloadList = new JSONArray();
					JSONObject payload	= new JSONObject();
					JSONObject vendor	= new JSONObject();
					JSONArray taxesList = new JSONArray();
					JSONObject taxes	= new JSONObject();
					JSONArray itemsList = new JSONArray();
					JSONObject items	= new JSONObject();
					payload.put("deliveryCenterId", iMap.get("ATTR_01"));           		//Delivery center id
					payload.put("customerInvoiceNumber", iMap.get("LEGACY_IV_NO"));			//kep invoice id 
					payload.put("date", currentdate2);										//인보이스 전송일시	
					payload.put("invoicedDate", currentdate3);								//배송일시	
					
					if ("C".equals(iMap.get("STATUS"))) {
						payload.put("deleted", "false");									//삭제여부	
					}else {
						payload.put("deleted", "true");										//삭제여부	
					}
					
					
					payload.put("discount", 0);												//고정값 , 할인금액 
					payload.put("dueDate", currentdate3);									//배송일시와 동일
					payload.put("fileAvailable", "false");									//고정값 , 파일 전송 여부
					payload.put("itemsQuantity", Integer.parseInt(iMap.get("ITEM_QTY")));	//상품총수량
					payload.put("orderId", iMap.get("LEGACY_PO_NO"));						//비즈 주문 번호
					payload.put("paymentType", "REWARDS_POINTS");							//고정값
					payload.put("status", "CLOSED");										//고정값
					payload.put("subtotal", 0);												//고정값 소계
					payload.put("tax", 0);													//고정값 세액
					payload.put("total", "0");												//고정값 소계 + 세액
					payload.put("beesAccountId", iMap.get("ATTR_02"));						//BEES Account id
					
					vendor.put("invoiceId",iMap.get("LEGACY_IV_NO"));	//송장번호
					payload.put("vendor", vendor);
					
					taxes.put("taxAmount", 0);												//고정값 세금총액
					taxes.put("taxId", "부가세");												//고정값 세금 ID
					taxesList.add(taxes);
					payload.put("taxes", taxesList);
					
					payload.put("deposit", 0);												//고정값
					payload.put("paymentTerm", null);										//고정값
					
					
					items.put("discount", 0);												//고정값 상품할인액
					items.put("price", 0);													//고정값 상품단가
					items.put("quantity", 2);												//수량 
					items.put("subtotal", 2);												//고정값 소계
					items.put("tax", 0);													//고정값 세금
					items.put("total", 0);													//고정값 총액
					items.put("vendorItemId", iMap.get("BUYER_ITEM_NO"));					//상품 ID
					items.put("freeGood", false);											//고정값
					itemsList.add(items);
					payload.put("items", itemsList);
					
					payloadList.add(payload);
					
					target.put("entity", "INVOICES");
					target.put("version", "v3");
					target.put("payload", payloadList);
					
					String pattern = "yyyyMMddHHmmss";
					SimpleDateFormat formatter = new SimpleDateFormat(pattern, Locale);
					String currentdate = formatter.format(today);
					
					con.setRequestMethod("POST");
					con.setRequestProperty("Content-Type", "application/json");
					con.setDoOutput(true);
					con.setDoInput(true);
					con.setRequestProperty("country", "KR");
					con.setRequestProperty("ws-id", "1078185880");
					con.setRequestProperty("Authorization", authorization);
					con.setRequestProperty("Request-Trace-Id", "KEDS00001_" + currentdate +"_invoice_0002.001");
					con.setConnectTimeout(1000 * 60);
					con.setReadTimeout(5000);
					con.setUseCaches(false);
					
					OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
					wr.write(target.toString());
					wr.flush();
					wr.close();
					
					StringBuilder sb = new StringBuilder();
					if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						String line;
						while ((line = br.readLine()) != null) {
							sb.append(line).append("\n");
						}
						br.close();
						JSONParser jsonParser = new JSONParser();
						JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
			
					} else {
			
						BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
						String line;
						while ((line = br.readLine()) != null) {
							sb.append(line).append("\n");
						}
						br.close();
						JSONParser jsonParser = new JSONParser();
						JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
						
						resultFlag = "E";
					}
				
				} catch (Exception e) {
					e.printStackTrace();
					log.error("ObBeerIvServiceImpl execute Error : " + e.getMessage());
					resultFlag = "E";
				}finally {
					con.disconnect();
					iMap.put("FLAG", resultFlag);
					obDao.updateObIvSendResult(iMap);
				}
			}
		}
	}
	
	
	
	private Map<String, String> getAccesTokenAPI(String tokenApiURL) {
		Map<String, String> returnData = new HashMap<String, String>();
		HttpURLConnection httpUrlConn = null;
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
				
				httpUrlConn.disconnect();
				
				JSONObject jsonObj1 = (JSONObject) jsonResponse;
				JSONObject jsonObj2 = (JSONObject) jsonObj1.get("Message");
	        	
				returnData.put("token",(String)jsonObj2.get("token"));
				
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
				log.info("ObBeerIvServiceImpl Token RESULT ERR!!!!" +jsonResponse);	
	        }
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ObBeerIvServiceImpl Token execute Error : " + e.getMessage());
		}
		return returnData;
	}

}
