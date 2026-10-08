package com.kep.hans.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.hans.dao.HansDao;
import com.kep.hans.dao.HansDaoImpl;

public class HansPoStatusServiceImpl implements HansPoStatusService {

	private Logger log = Logger.getLogger(this.getClass().getName());

	@Override
	public void execute() throws Exception {
		String apiUrl = CommonProperty.getHans_URL() + "/MRO_SAP_RECV_PO_CHANGE";
		HansDao dao = new HansDaoImpl(); 
		HttpURLConnection httpUrlConn = null;
		JSONArray ZKEP_PO = new JSONArray();
		JSONObject jsonObj2 = new JSONObject();

		List<Map<String,Object>> map = dao.selectHansPoStatusList();
		
		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				String ifFlag = "E";
				String ifMsg = "";

				try {
					JSONObject jsonObj = new JSONObject();

					jsonObj.put("EBELP", map.get(i).get("LEGACY_PO_SEQ"));  	//sap 발주항번
					jsonObj.put("MENGE", map.get(i).get("ITEM_QTY"));   		//수량
					jsonObj.put("MEINS", map.get(i).get("UNIT_MEASURE"));		//단위
					jsonObj.put("EEIND", map.get(i).get("RD_DATE"));			//납품예정일
					jsonObj.put("NETPR", map.get(i).get("UNIT_PRICE")); 		//단가
					jsonObj.put("PEINH","1");                           		//가격단위
					if("D".equals(map.get(i).get("STATUS"))) {					//삭제지시자 삭제 시 X 전송 
						jsonObj.put("LOEKZ","X");						      
					}else {
						jsonObj.put("LOEKZ","");						   
					}
					jsonObj.put("ELIKZ","");    			  		    		//종결 시 'X' 전송
					jsonObj.put("ZDOC_NUM", map.get(i).get("KEY_1"));   		//MRO 문서번호	
					jsonObj.put("ZDOC_SEQ", map.get(i).get("KEY_2"));   		//MRO 문서품목번호

					ZKEP_PO.add(jsonObj);

					jsonObj2.put("IV_EBELN", map.get(i).get("LEGACY_PO_NO"));  //sap 발주번호
					jsonObj2.put("IT_ITEM", ZKEP_PO);

					URL url = new URL(apiUrl);

					httpUrlConn = (HttpURLConnection) url.openConnection();

					httpUrlConn.setRequestMethod("POST");
					httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
					httpUrlConn.setDoOutput(true);
					httpUrlConn.setDoInput(true);
					httpUrlConn.setUseCaches(false);
					httpUrlConn.setConnectTimeout(10000);
					httpUrlConn.setReadTimeout(10000);

					OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
					wr.write(jsonObj2.toJSONString());
					wr.flush();
					wr.close();

					int responseCode = httpUrlConn.getResponseCode();

					StringBuilder sb = new StringBuilder();
					BufferedReader br = null;

					if (responseCode == HttpURLConnection.HTTP_OK) {
						br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));
					} else {
						br = new BufferedReader(new InputStreamReader(httpUrlConn.getErrorStream(), "utf-8"));
					}

					String line;

					while ((line = br.readLine()) != null) {
						sb.append(line);
					}

					br.close();

					log.info("Hansol Response : " + sb.toString());

					if (responseCode != HttpURLConnection.HTTP_OK) {
						throw new Exception(sb.toString());
					}

					JSONParser parser = new JSONParser();
					JSONObject root = (JSONObject) parser.parse(sb.toString());
					JSONArray etReturn = (JSONArray) root.get("ET_RETURN");

					if (etReturn != null && !etReturn.isEmpty()) {

						JSONObject item = (JSONObject) etReturn.get(0);

						ifFlag = String.valueOf(item.get("TYPE"));
						ifMsg = String.valueOf(item.get("MESSAGE"));
					}

				} catch (Exception e) {

					ifFlag = "E";

					if (ifMsg == null || "".equals(ifMsg)) {
						ifMsg = e.getMessage();
					}

					log.error("Hans PO Change Error", e);

				} finally {
					try {
						Map<String, Object> paramMap = new HashMap<String, Object>();

						paramMap.put("IF_FLAG", ifFlag);
						paramMap.put("IF_MSG", ifMsg);
						paramMap.put("BUYER", map.get(i).get("BUYER"));
						paramMap.put("PO_NO", map.get(i).get("PO_NO"));
						paramMap.put("PO_SEQ", map.get(i).get("PO_SEQ"));
						paramMap.put("STATUS", map.get(i).get("STATUS"));
						paramMap.put("SEQ", map.get(i).get("SEQ"));

						dao.updatePoStatusResult(paramMap);

					} catch (Exception e) {
						log.error("DB Update Error", e);
					} finally {
						if (httpUrlConn != null) {
							httpUrlConn.disconnect();
						}
					}
				}
			}
		}	
	}
}
