package com.kep.hans.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.kep.common.CommonProperty;

public class HansPrCheckServiceImpl implements HansPrCheckService {



	private Logger log = Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() throws Exception {
		String apiUrl = CommonProperty.getHans_URL() + "/MRO_SAP_RECV_MAT_CHECK";
		HttpURLConnection httpUrlConn = null;
		JSONArray ZKEP_PO = new JSONArray();
		JSONObject jsonObj2 = new JSONObject();

		try {

			JSONObject jsonObj = new JSONObject();
			JSONObject jsonObj4 = new JSONObject();
			JSONObject jsonObj3 = new JSONObject();

			jsonObj.put("ZDOC_NUM","PXTEST260005");
			jsonObj.put("ZDOC_SEQ","000001");
			jsonObj.put("MATNR","800510");
			jsonObj.put("TXZ01","AIR PULSHING CARD,10 POINT");
			jsonObj.put("MENGE","1");
			jsonObj.put("MEINS","EA");
			jsonObj.put("MATKL","8140");
			jsonObj.put("LGORT","7000");
			
			
			jsonObj4.put("ZDOC_NUM","PXTEST260005");
			jsonObj4.put("ZDOC_SEQ","000002");
			jsonObj4.put("MATNR","808232");
			jsonObj4.put("TXZ01","근접SENSOR,IGA-3008-BPKG/US");
			jsonObj4.put("MENGE","1");
			jsonObj4.put("MEINS","EA");
			jsonObj4.put("MATKL","8170");
			jsonObj4.put("LGORT","7000");
			
			
			jsonObj3.put("ZDOC_NUM","PXTEST260005");
			jsonObj3.put("ZDOC_SEQ","000003");
			jsonObj3.put("MATNR","804102");
			jsonObj3.put("TXZ01","감속기,SA67A/T,17.28:1,SEW");
			jsonObj3.put("MENGE","2");
			jsonObj3.put("MEINS","EA");
			jsonObj3.put("MATKL","8200");
			jsonObj3.put("LGORT","7000");
		
			ZKEP_PO.add(jsonObj);
			ZKEP_PO.add(jsonObj4);
			ZKEP_PO.add(jsonObj3);

			jsonObj2.put("IT_ITEM", ZKEP_PO);

			log.info("jsonObj2 RESULT !!!! " + jsonObj2.toString());

			// ===========================
			// [추가] body 문자열 생성
			// ===========================
			String body = jsonObj2.toString();

			// ===========================
			// [추가] byte[] 변환
			// ===========================
			byte[] postData = body.getBytes("UTF-8");

			URL url = new URL(apiUrl);

			httpUrlConn = (HttpURLConnection) url.openConnection();

			httpUrlConn.setRequestMethod("POST");

			httpUrlConn.setRequestProperty(
					"Content-Type",
					"application/json; charset=UTF-8"
			);

			// ===========================
			// [삭제 추천]
			// webMethods에서 꼬이는 경우 있음
			// ===========================
			// httpUrlConn.setRequestProperty("Accept", "application/json");

			httpUrlConn.setDoOutput(true);

			httpUrlConn.setDoInput(true);

			// ===========================
			// [추가]
			// 캐시 사용 안함
			// ===========================
			httpUrlConn.setUseCaches(false);

			// ===========================
			// [추가]
			// redirect 여부 확인용
			// ===========================
			httpUrlConn.setInstanceFollowRedirects(false);

			// ===========================
			// [핵심 추가]
			// chunked 방지
			// Content-Length 고정
			// ===========================
			httpUrlConn.setFixedLengthStreamingMode(postData.length);

			// ===========================
			// [추가] 요청 body 로그
			// ===========================
			log.info("REQUEST BODY : " + body);

			// =====================================================
			// [기존 OutputStreamWriter 삭제]
			//
			// OutputStreamWriter wr =
			//    new OutputStreamWriter(
			//        httpUrlConn.getOutputStream(), "utf-8");
			//
			// wr.write(jsonObj2.toString());
			// wr.flush();
			// wr.close();
			// =====================================================

			// ===========================
			// [변경] OutputStream 방식 사용
			// ===========================
			OutputStream os = httpUrlConn.getOutputStream();

			os.write(postData);

			os.flush();

			os.close();

			// ===========================
			// [변경]
			// responseCode 변수 사용
			// ===========================
			int responseCode = httpUrlConn.getResponseCode();

			log.info("RESPONSE CODE : " + responseCode);

			// ===========================
			// [추가]
			// redirect 확인용
			// ===========================
			log.info(
					"LOCATION : "
					+ httpUrlConn.getHeaderField("Location")
			);

			StringBuilder sb = new StringBuilder();

			// ===========================
			// [변경]
			// 기존 getResponseCode() 직접 호출 제거
			// ===========================
			if (responseCode == HttpURLConnection.HTTP_OK) {

				BufferedReader br =
						new BufferedReader(
								new InputStreamReader(
										httpUrlConn.getInputStream(),
										"utf-8"
								)
						);

				String line;

				while ((line = br.readLine()) != null) {

					sb.append(line).append("\n");
				}

				br.close();

				log.info("response" + sb.toString());
				/*JSONParser jsonParser = new JSONParser();
				
				JSONObject jsonResponse =
						(JSONObject) jsonParser.parse(sb.toString());
				
				log.info("jsonResponse RESULT !!!! "
						+ jsonResponse.toString());*/

				httpUrlConn.disconnect();

			} else {

				BufferedReader br =
						new BufferedReader(
								new InputStreamReader(
										httpUrlConn.getErrorStream(),
										"utf-8"
								)
						);

				String line;

				while ((line = br.readLine()) != null) {

					sb.append(line).append("\n");
				}

				br.close();

				log.info("ERROR RESPONSE : " + sb.toString());

				httpUrlConn.disconnect();
			}

		} catch (Exception e) {

			e.printStackTrace();

			log.error("execute Error : " + e.getMessage());
		}
	}


}
