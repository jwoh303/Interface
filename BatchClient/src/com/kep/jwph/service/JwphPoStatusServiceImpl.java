package com.kep.jwph.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.jwph.dao.JwphDao;
import com.kep.jwph.dao.JwphDaoImpl;

public class JwphPoStatusServiceImpl implements JwphPoStatusService {

	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void execute() throws Exception {
		/*APPROVE	주문 승인
		SHIPPING_ING	배송 시작
		SHIPPING_COMPLETE	배송 완료
		CANCEL	주문 취소
		REJECT	주문 반려*/
		
		/*
		KEY_1   //KEP 발주번호
		KEY_2   //KEP 발주항번 
		KEY_3   //구분 값 PO, IV, DI. RE, CA
		KEY_4   //생성 날짜
		KEY_5   //고객사 발주 번호 ^ 고객사 발주 항번
		KEY_6   //차수
		KEY_7   //사유 OR 예상 출고 날짜
		KEY_8   //수량 
		*/          
		
		JwphDao dao = new JwphDaoImpl();
		String ApiURL =  CommonProperty.getJWPH_URL() + "/order/transaction";

		List<Map<String,String>> map = dao.selectPoStatusTargetList();
		int size = map.size();	
		
		if (size > 0) {
			for (Map<String, String> iMap : map) {
				URL url = null;
				url = new URL(ApiURL);
				HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
				String resultFlag = "Y";
				
				try {
					JSONObject target	= new JSONObject();
					
					  /* 상태값 처리 */
	                String rawStatus = iMap.get("KEY_3");

	                if (rawStatus == null || !rawStatus.contains("_")) {
	                    log.error("KEY_3 format error : " + rawStatus);
	                    throw new Exception("Invalid KEY_3 format : " + rawStatus);
	                }

	                String status = rawStatus.substring(rawStatus.indexOf("_") + 1);

	                /* 주문번호 분리 */
	                String rawKey5 = iMap.get("KEY_5");

	                if (rawKey5 == null || !rawKey5.contains("^")) {
	                    log.error("KEY_5 format error : " + rawKey5);
	                    throw new Exception("Invalid KEY_5 format : " + rawKey5);
	                }
	                String[] date = rawKey5.split("\\^");

					target.put("no",     date[0]);
					target.put("itemNo", date[1]);
					target.put("status", status);
					target.put("quantity", iMap.get("KEY_8"));
					target.put("interfaceOrderNo", iMap.get("KEY_1"));
				
					if("CANCEL".equals(status)||"REJECT".equals(status)||"APPROVE".equals(status)){
						target.put("interfaceOrderItemNo", iMap.get("KEY_2"));
					}else {
						target.put("interfaceOrderItemNo", iMap.get("KEY_6"));
					}
					
					if("CANCEL".equals(status)||"REJECT".equals(status)){
						target.put("comment", iMap.get("KEY_7"));
					} 
					
					if("APPROVE".equals(status)) {
						target.put("deliveryStartDate", iMap.get("KEY_7"));
					}else {
						target.put("transactionDatetime", iMap.get("KEY_4"));
					}
					
					log.info("target ||:" + target);
					
					con.setRequestMethod("POST");
					con.setRequestProperty("Content-Type", "application/json");
					con.setDoOutput(true);
					con.setDoInput(true);
					con.setConnectTimeout(1000 * 60);
					con.setReadTimeout(5000);
					
					OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
					wr.write(target.toString());
					wr.flush();
					wr.close();
					
					int responseCode = con.getResponseCode();

                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        resultFlag = "Y";
                        log.info("API 호출 성공 (200)");
                    } else {
                        resultFlag = "E";
                        log.error("API 호출 실패, responseCode: " + responseCode);
                    }
				}catch (Exception e) {
					resultFlag = "E";
					e.printStackTrace();
					log.error("JwphPoStatusServiceImpl execute Error : " + e.getMessage());
				}finally {
					con.disconnect();
					iMap.put("FLAG", resultFlag);
					dao.updateJwphAppSubmitResult(iMap);
				}
			}
		}
	}
	
}
