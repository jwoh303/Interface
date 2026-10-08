package com.kep.nexe.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.nexe.dao.PrSubmitDao;
import com.kep.nexe.dao.PrSubmitDaoImpl;

public class NexePrSubmitServiceImpl implements NexePrSubmitService {

	private Logger log = Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() throws Exception {
		PrSubmitDao dao = new PrSubmitDaoImpl();

		//BASIC 인증
		String basicKey = Base64.getEncoder().encodeToString(("paranoid:survive").getBytes());
		String apiUrl =  CommonProperty.getNEXE_URL() + "1001_KEP_MM_S/Request";

		HttpURLConnection httpUrlConn = null;

		//대상 조회
		List<Map<String, String>> map = dao.selectPrTargetList();
		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				Map<String, String> resultMap = map.get(i);
				resultMap.put("DOC_TYPE", "PR");
				
				List<Map<String, String>> pMaps = dao.selectPrList(map.get(i));
				JSONArray ZKEP_PO = new JSONArray();
				JSONObject jsonObj2 = new JSONObject();
				JSONObject jsonObj3 = new JSONObject();

				int size = pMaps.size();
				try {
					if (size > 0) {
						for (Map<String, String> iMap : pMaps) {
							JSONObject jsonObj = new JSONObject();
							if ("5".contentEquals(CommonProperty.getDB_CONN())) {
								jsonObj.put("BUKRS","CZ10");           					 //회사코드
								jsonObj.put("CURRENCY", iMap.get("KEY_4")); 			//통화키
							}else if ("7".contentEquals(CommonProperty.getDB_CONN()) || "8".contentEquals(CommonProperty.getDB_CONN())) {
								jsonObj.put("BUKRS","CN10");           					 //중국
								jsonObj.put("CURRENCY", "CNY"); 						//통화키
							}else {
								jsonObj.put("BUKRS","KR10");           					 //회사코드
								jsonObj.put("CURRENCY", "KRW"); 						//통화키
							}
							
							jsonObj.put("STATUS", iMap.get("STATUS")); 					//상태값
							jsonObj.put("BANFN", ""); 									//SAP구매요청번호
							jsonObj.put("BNFPO", ""); 									//SAP구매요청항번
							jsonObj.put("PR_NO", iMap.get("BUYER")+iMap.get("DOC_NO")); //kep발주번호
							jsonObj.put("PR_SEQ", iMap.get("DOC_SEQ")); 				//kep발주항번
							jsonObj.put("ADD_DATE", iMap.get("ADD_DATE")); 				//주문생성일
							jsonObj.put("BUYER_ITEM_NO",  iMap.get("BUYER_ITEM_NO"));	//품목코드
							jsonObj.put("PR_REMARK",  iMap.get("DESCRIPTION")); 		//주문 비고
							jsonObj.put("PLANT", iMap.get("PLANT")); 					//플랜트
							jsonObj.put("ITEM_QTY", iMap.get("ITEM_QTY")); 				//주문수량
							jsonObj.put("UNIT_MEASURE", iMap.get("UNIT_MEASURE")); 		//단위
							jsonObj.put("PER", "1"); 									//per
							jsonObj.put("UNIT_PRICE", iMap.get("UNIT_PRICE")); 			//단가
							jsonObj.put("ITEM_AMT", iMap.get("ITEM_AMT")); 				//금액
							jsonObj.put("RD_DATE", iMap.get("RD_DATE")); 				//납품요청일
							jsonObj.put("KNTTP", iMap.get("KEY_1")); 	//계정지정범주 (K : 코스트센터, A: 고정자산)
							if("K".equals(iMap.get("KEY_1"))) {
								jsonObj.put("KOSTL", iMap.get("BUDGET_DEPT"));			//코스트 센터 (K일때 입력)
								jsonObj.put("SAKTO", iMap.get("ACCOUNT_TYPE")); 		//G/L 계정 번호 (K일때 입력)
								jsonObj.put("ANLN1", ""); 								//고정 자산 번호 (A일때 입력) 
								jsonObj.put("AUFNR", ""); 								//오더 번호 (A일때 입력) 빈 값으로 전송 sap 에서 맵핑해주기로 함 
							}else {
								jsonObj.put("KOSTL", ""); 								//코스트 센터 (K일때 입력)
								jsonObj.put("SAKTO", ""); 								//G/L 계정 번호 (K일때 입력)
								jsonObj.put("ANLN1", iMap.get("REF_PR_NO")); 			//고정 자산 번호 (A일때 입력) 
								jsonObj.put("AUFNR", ""); 								//오더 번호 (A일때 입력) 빈 값으로 전송 sap 에서 맵핑해주기로 함 
							}
							jsonObj.put("AFNAM",  iMap.get("LEGACY_USER_ID")); 			//요청자
							jsonObj.put("IF_FLAG", ""); 								//flag
							jsonObj.put("IF_MSG", ""); 									//msg

							ZKEP_PO.add(jsonObj);
						}
						jsonObj2.put("ZKEP_PO", ZKEP_PO);
						jsonObj3.put("Request", jsonObj2);

						log.info("jsonResponse ZKEP_PO !!!!" + jsonObj3.toString());

						URL url = new URL(apiUrl);
						httpUrlConn = (HttpURLConnection) url.openConnection();
						httpUrlConn.setRequestMethod("POST");
						httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
						httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
						httpUrlConn.setDoOutput(true);
						httpUrlConn.setDoInput(true);
						httpUrlConn.setRequestProperty("Accept", "application/json");
				
						OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
						wr.write(jsonObj3.toString());
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
							JSONObject resultObj1 = (JSONObject) jsonResponse;
							JSONObject resultObj2 = (JSONObject) resultObj1.get("Response");
							JSONArray resultArray = (JSONArray)resultObj2.get("ZKEP_PO");
							log.info("jsonResponse RESULT !!!!" + jsonResponse.toString());
							
							httpUrlConn.disconnect();
							
							for (int j = 0; j < resultArray.size(); j++) {
								JSONObject resultArrayObj = (JSONObject) resultArray.get(j);
								String buyer = (String) resultArrayObj.get("PR_NO");
								
								resultMap.put("BUYER", buyer.substring(0, 10));
								resultMap.put("DOC_NO", buyer.substring(10));
								resultMap.put("DOC_SEQ", (String)resultArrayObj.get("PR_SEQ"));
								resultMap.put("STATUS", (String)resultArrayObj.get("STATUS"));
								
								if(resultArrayObj.get("IF_MSG")==null) {
									resultMap.put("IF_MSG", "");
								}else {
									resultMap.put("IF_MSG", (String)resultArrayObj.get("IF_MSG"));
								}
								
								if("S".equals((String)resultArrayObj.get("IF_FLAG")) && "C".equals((String)resultArrayObj.get("STATUS"))) {
									resultMap.put("IF_FLAG", "S");
								}else if("S".equals((String)resultArrayObj.get("IF_FLAG")) && "D".equals((String)resultArrayObj.get("STATUS"))) {
									resultMap.put("IF_FLAG", "Y");
								}else {
									resultMap.put("IF_FLAG", "E");
								}
								dao.updateNexePrSendResult(resultMap);
							}
						} else {
							BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
							String line;
							while ((line = br.readLine()) != null) {
								sb.append(line).append("\n");
							}
							br.close();
							JSONParser jsonParser = new JSONParser();
							JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
							log.info("jsonResponse RESULT !!!!" + jsonResponse.toString());

							httpUrlConn.disconnect();
						}
					}

				} catch (Exception e) {
					e.printStackTrace();
					log.error("execute Error : " + e.getMessage());
				}
			}

		}
	}
}
