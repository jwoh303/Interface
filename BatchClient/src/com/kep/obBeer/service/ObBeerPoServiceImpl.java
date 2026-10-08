package com.kep.obBeer.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.obBeer.dao.ObBeerPoDao;
import com.kep.obBeer.dao.ObBeerPoDaoImpl;

public class ObBeerPoServiceImpl implements ObBeerPoService {

	private Logger log = Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() throws Exception {

		ObBeerPoDao obDao = new ObBeerPoDaoImpl();
		
		String tokenApiURL = "https://api.bees-kconnect.com/eai/budweiser/eds/api/v1/token_0002";
		String orderApiURL = "https://api.bees-kconnect.com/eai/budweiser/eds/api/v1/orders/order_ksta_0003?country=KR&orderStatus=PENDING";
		
		for (int k = 0; k < 6; k++) {
			SimpleDateFormat Format = new SimpleDateFormat("yyyy-MM-dd");
			Calendar c1 = Calendar.getInstance();
			c1.add(Calendar.DATE, k);
			String strDate =  Format.format(c1.getTime());
		
			log.info("strDate :" + strDate);
		
			URL url = new URL(orderApiURL+"&deliveryDate="+strDate);
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			try {
				//토큰 받기
				Map<String, String> tokenMap = getAccesTokenAPI(tokenApiURL);
				String authorization = "Bearer " + tokenMap.get("token").trim();
				
				Date today = new Date();
				Locale Locale = new Locale("KOREAN", "KOREA");
				String pattern = "yyyyMMddHHmmss";
				SimpleDateFormat formatter = new SimpleDateFormat(pattern, Locale);
				String currentdate = formatter.format(today);
				String response = "";
	
				//주문 받기
				con.setRequestMethod("GET");
				con.setRequestProperty("Authorization", authorization);
				con.setRequestProperty("Cache-Control", "no-cache");
				con.setRequestProperty("Accept", "application/json");
				con.setRequestProperty("Request-Trace-Id", "KEDS00001_" + currentdate + "_order_0001.001");
				con.setRequestProperty("Content-Type", "application/json");
				con.setRequestProperty("country", "KR");
				
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				StringBuffer sb = new StringBuffer();
				String inputline;
				
				while ((inputline = br.readLine()) != null) {
					sb.append(inputline);
				}
				br.close();
				
				response = sb.toString();
				JSONParser parser = new JSONParser();
				Object obj = parser.parse(response.toString());
				JSONObject jsonObj = (JSONObject) obj;
				JSONArray jsonArray = (JSONArray) jsonObj.get("message");
				JSONObject jsonObj1 = (JSONObject) jsonArray.get(0);
				
				String resultMsg =  jsonArray.toString();
				
				if(!"[null]".equals(resultMsg)) {
					JSONArray jsonArray1 = (JSONArray)jsonObj1.get("orders");
					for (int i = 0; i < jsonArray1.size(); i++) {
						Map<String, String> pMap = new HashMap<String, String>();
						JSONObject getObj = (JSONObject) jsonArray1.get(i);
							JSONArray itemArray = (JSONArray)getObj.get("items");
							
							//기본정보
							pMap.put("LEGACY_PO_NO",(String)getObj.get("orderNumber")); //발주번호
							pMap.put("IV_COLUMN",(String)getObj.get("beesAccountId")+"^"+(String)getObj.get("deliveryCenterId")); //IVCOLUMN
							
							String delDate = (String)getObj.get("deliveryDate");
							pMap.put("RD_DATE",delDate.replace("-", "")); //배송요청일
							String orDate = (String)getObj.get("orderDate");
							pMap.put("ADD_DATE",orDate.replace("-", "")); //배송요청일
							
							pMap.put("REMARK",(String)getObj.get("note")); //비고		
							
							JSONObject accountInfoObj = (JSONObject) getObj.get("accountInfo");
							pMap.put("REQ_USER_NAME",(String)accountInfoObj.get("name")); //요청자명				
							pMap.put("REQ_USER_INFO",(String)accountInfoObj.get("name") + " TEL:" + (String)accountInfoObj.get("phoneNumber")); //요청자명				
							pMap.put("DELY_TO_LOCATION_TEXT",(String)accountInfoObj.get("zipCode") + " " + (String)accountInfoObj.get("address") + " " + (String)accountInfoObj.get("name")); //도착지 상세 코드				
							
							//품목정보
							for (int j = 0; j < itemArray.size(); j++) { 
								JSONObject getItemObj = (JSONObject) itemArray.get(j);
								pMap.put("BUYER_ITEM_NO",(String)getItemObj.get("sku")); //품목 코드		
								pMap.put("ITEM_QTY", getItemObj.get("boxQuantity").toString()); //품목 코드		
								pMap.put("LEGACY_PO_SEQ",((String) getItemObj.get("sku")).replaceAll("OB_BEES", "")); //품목 코드		
								
								obDao.insertObBeerPo(pMap);
							}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ObBeerPoServiceImpl execute Error : " + e.getMessage());
			}finally {
				con.disconnect();
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
			Locale Locale = new Locale("KOREAN", "KOREA");
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
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());

				JSONObject jsonObj1 = (JSONObject) jsonResponse;
				JSONObject jsonObj2 = (JSONObject) jsonObj1.get("Message");

				returnData.put("token", (String) jsonObj2.get("token"));

				httpUrlConn.disconnect();
			} else {

				BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());

				httpUrlConn.disconnect();
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ObBeerPoServiceImpl Token execute Error : " + e.getMessage());
		}

		return returnData;
	}

}
