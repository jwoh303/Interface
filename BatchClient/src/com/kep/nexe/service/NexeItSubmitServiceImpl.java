package com.kep.nexe.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.nexe.dao.ItSubmitDao;
import com.kep.nexe.dao.ItSubmitDaoImpl;
import com.kep.nexe.dao.PrSubmitDao;
import com.kep.nexe.dao.PrSubmitDaoImpl;

public class NexeItSubmitServiceImpl implements NexeItSubmitService {

	private Logger log = Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() throws Exception {
		ItSubmitDao dao = new ItSubmitDaoImpl();

		//대상 생성 프로시져
		if ("2".contentEquals(CommonProperty.getDB_CONN()) || "8".contentEquals(CommonProperty.getDB_CONN())) {
			dao.execQuotationSend();
		}
		
		//BASIC 인증
		String basicKey = Base64.getEncoder().encodeToString(("paranoid:survive").getBytes());	
		String apiUrl =  CommonProperty.getNEXE_URL()  + "1002_KEP_MM_S/Request";
		
		HttpURLConnection httpUrlConn = null;
	
		List<Map<String, String>> map = dao.selectItemTargetList();
		
		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				Map<String, String> resultMap = map.get(i);
				resultMap.put("DOC_TYPE", "IT");
				try {

					URL url = new URL(apiUrl);
					httpUrlConn = (HttpURLConnection) url.openConnection();
					httpUrlConn.setRequestMethod("POST");
					httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
					httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
					httpUrlConn.setDoOutput(true);
					httpUrlConn.setDoInput(true); 
					httpUrlConn.setRequestProperty("Accept", "application/json");
					
					JSONArray ZKEP_IT = new JSONArray();
					JSONObject jsonObj = new JSONObject();
					JSONObject jsonObj2 = new JSONObject();
					JSONObject jsonObj3 = new JSONObject();
					
					if ("5".contentEquals(CommonProperty.getDB_CONN())) {
						if("C".equals(map.get(i).get("STATUS"))) {
							jsonObj.put("ITEM_NO", map.get(i).get("BUYER_ITEM_NO"));    //sap 자재코드
							jsonObj.put("BUYER_ITEM_NO",map.get(i).get("BELOW_COMORG_CODE")+map.get(i).get("QUOTATION_NO")+map.get(i).get("QUOTATION_SEQ"));  //kep품목코드
						}else{
							jsonObj.put("ITEM_NO", map.get(i).get("BUYER_ITEM_NO"));    //sap 자재코드
							jsonObj.put("BUYER_ITEM_NO",map.get(i).get("BUYER_ITEM_NO"));  //kep품목코드
						}
						jsonObj.put("BUKRS","CZ10");         							//회사코드
					}else if("7".contentEquals(CommonProperty.getDB_CONN())|| "8".contentEquals(CommonProperty.getDB_CONN())) {
						if("C".equals(map.get(i).get("STATUS"))) {
							jsonObj.put("ITEM_NO", "");         					 	//sap 자재코드
							jsonObj.put("BUYER_ITEM_NO",map.get(i).get("BELOW_COMORG_CODE")+map.get(i).get("QUOTATION_NO")+map.get(i).get("QUOTATION_SEQ"));  //kep품목코드
						}else{
							jsonObj.put("ITEM_NO", map.get(i).get("BUYER_ITEM_NO"));    //sap 자재코드
							jsonObj.put("BUYER_ITEM_NO",map.get(i).get("BUYER_ITEM_NO"));  //kep품목코드
						}
						jsonObj.put("BUKRS","CN10");     
					}else {
						if("C".equals(map.get(i).get("STATUS"))) {
							jsonObj.put("ITEM_NO", "");         					 	//sap 자재코드
							jsonObj.put("BUYER_ITEM_NO",map.get(i).get("BELOW_COMORG_CODE")+map.get(i).get("QUOTATION_NO")+map.get(i).get("QUOTATION_SEQ"));  //kep품목코드
						}else{
							jsonObj.put("ITEM_NO", map.get(i).get("BUYER_ITEM_NO"));    //sap 자재코드
							jsonObj.put("BUYER_ITEM_NO",map.get(i).get("BUYER_ITEM_NO"));  //kep품목코드
						}
						jsonObj.put("BUKRS","KR10");           					 		//회사코드
					}
					jsonObj.put("DESCRIPTION", map.get(i).get("DESCRIPTION"));     		//상품명
					jsonObj.put("SPECIFICATION", map.get(i).get("SPECIFICATION")); 		//상품규격
					jsonObj.put("UNIT_MEASURE", map.get(i).get("UNIT_MEASURE"));   		//구매오더단위
					jsonObj.put("PLANT", map.get(i).get("PLANT"));           		 	//플랜트
					jsonObj.put("CURRENCY", map.get(i).get("CURRENCY"));           		//통화키
					jsonObj.put("STATUS", map.get(i).get("STATUS"));           			//상태값
					jsonObj.put("MOQ", map.get(i).get("MOQ"));                     		//최소발주수량
					jsonObj.put("DELIVERY_LT", map.get(i).get("DELIVERY_LT"));     		//납품일수
					jsonObj.put("UNIT_PRICE", map.get(i).get("UNIT_PRICE"));       		//단가
					jsonObj.put("PUR_UNIT_QTY", map.get(i).get("PUR_UNIT_QTY"));   		//per 체코는 달라질수 있음 확인해야됨
					jsonObj.put("FROM_DATE", map.get(i).get("FROM_DATE"));       	 	//시작일
					jsonObj.put("SELL_CLOSE_DATE", map.get(i).get("SELL_CLOSE_DATE")); 	//종료일
					jsonObj.put("ITEM_MAKER", map.get(i).get("ITEM_MAKER")); 		//제조사코드
					jsonObj.put("ITEM_CATCD", map.get(i).get("ITEM_CATCD")); 		//카테고리코드
					jsonObj.put("ITEM_CATNM", map.get(i).get("ITEM_CATNM")); 		//카테고리내역
					jsonObj.put("IF_FLAG","");         						 			//flag
					jsonObj.put("IF_MSG","");          						 			//msg
					
					ZKEP_IT.add(jsonObj);
					
					jsonObj2.put("ZKEP_IT",ZKEP_IT);
					jsonObj3.put("Request",jsonObj2);

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
						JSONArray resultArray = (JSONArray)resultObj2.get("ZKEP_IT");

						for (int j = 0; j < resultArray.size(); j++) {
							JSONObject resultArrayObj = (JSONObject) resultArray.get(j);
							
							resultMap.put("MSG", (String)resultArrayObj.get("IF_MSG"));
							if("S".equals((String)resultArrayObj.get("IF_FLAG"))) {
								resultMap.put("FLAG", "Y");
							}else {
								resultMap.put("FLAG", "E");
							}
							resultMap.put("IF_FLAG", (String)resultArrayObj.get("IF_FLAG"));
							resultMap.put("ITEM_NO", (String)resultArrayObj.get("ITEM_NO"));
							
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
						resultMap.put("MSG", "error :");
						resultMap.put("FLAG", "E");
						resultMap.put("IF_FLAG", "E");
						log.info("jsonResponse RESULT !!!!" + jsonResponse.toString());
					}
				} catch (Exception e) {
					e.printStackTrace();
					resultMap.put("MSG", e.getMessage());
					resultMap.put("FLAG", "E");
					resultMap.put("IF_FLAG", "E");
					log.error("execute Error : " + e.getMessage());
				}finally {
					httpUrlConn.disconnect();
					dao.updateNexeItSendResult(resultMap);
					dao.insertNexeItSendResult(resultMap);
				}
			}
		
			//대상 생성 프로시져
			if ("2".contentEquals(CommonProperty.getDB_CONN()) || "8".contentEquals(CommonProperty.getDB_CONN())) {
				dao.execRtnProcess();
			}
			
		}
	
	}

}
