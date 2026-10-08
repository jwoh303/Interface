package com.kep.hans.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.hans.dao.HansDao;
import com.kep.hans.dao.HansDaoImpl;

public class HansGrSubmitServiceImpl implements HansGrSubmitService {

	private Logger log = Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() throws Exception {
		String createUrl = CommonProperty.getHans_URL() + "/MRO_SAP_RECV_GR_CREATE";
		String cancelUrl = CommonProperty.getHans_URL() + "/MRO_SAP_RECV_GR_CANCEL";
		
		HansDao dao = new HansDaoImpl();

	    List<Map<String, Object>> list = dao.selectHansGrList();

	    if (list == null || list.isEmpty()) {
	        return;
	    }

	    for (Map<String, Object> iMap : list) {
	    	HttpURLConnection httpUrlConn = null;
	    	try {
	    		   String apiUrl = "";
	               JSONObject requestJson = null;

	               String status = String.valueOf(iMap.get("STATUS"));

	               if ("C".equals(status)) {
	                   requestJson = makeCreateJson(iMap);
	                   apiUrl = createUrl;
	               } else if ("D".equals(status)) {
	                   requestJson = makeCancelJson(iMap);
	                   apiUrl = cancelUrl;
	               } else {
	                   continue;
	               }

	               log.info("Request URL : " + apiUrl);
	               log.info("Request JSON : " + requestJson.toJSONString());

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
	               wr.write(requestJson.toJSONString());
	               wr.flush();
	               wr.close();

	               int responseCode = httpUrlConn.getResponseCode();

	               StringBuilder sb = new StringBuilder();

	               if (responseCode == HttpURLConnection.HTTP_OK) {

	                   BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(), "utf-8"));

	                   String line;

	                   while ((line = br.readLine()) != null) {
	                       sb.append(line);
	                   }

	                   br.close();

	                   log.info("Response : " + sb.toString());

	                   JSONParser parser = new JSONParser();
	                   JSONObject root = (JSONObject) parser.parse(sb.toString());
	                   JSONArray etReturn = (JSONArray) root.get("ET_RETURN");

	                   if (etReturn == null || etReturn.isEmpty()) {
	                       throw new Exception("SAP 응답에 ET_RETURN이 없습니다.");
	                   }

	                   JSONObject item = (JSONObject) etReturn.get(0);

	                   if("S".equals(String.valueOf(item.get("TYPE")))) {
	                	   iMap.put("TYPE", "Y");
	                   }else {
	                	   iMap.put("TYPE", String.valueOf(item.get("TYPE")));
					}
	                   iMap.put("MESSAGE", String.valueOf(item.get("MESSAGE")));
	                   iMap.put("KEY_8", String.valueOf(item.get("MJAHR")));
	                   iMap.put("KEY_9", String.valueOf(item.get("MBLNR")));
	                   iMap.put("KEY_10", String.valueOf(item.get("ZEILE")));

	               } else {

	                   BufferedReader br = new BufferedReader(new InputStreamReader(httpUrlConn.getErrorStream(), "utf-8"));
	                   String line;
	                   while ((line = br.readLine()) != null) {
	                       sb.append(line);
	                   }

	                   br.close();

	                   iMap.put("TYPE", "E");
	                   iMap.put("MESSAGE", sb.toString());
	               }

			} catch (Exception e) {
				  log.error("Hans GR Error", e);
		          iMap.put("TYPE", "E");
		          iMap.put("MESSAGE", e.getMessage());
			}finally {
				 if (httpUrlConn != null) {
		                httpUrlConn.disconnect();
		         }
		            dao.updateHansGr(iMap);
			}
	    }
	}
	
	public JSONObject makeCreateJson(Map<String, Object> iMap) {
		JSONObject root = new JSONObject();

		JSONObject isHeader = new JSONObject();

		isHeader.put("BUDAT", iMap.get("GR_DATE"));
		isHeader.put("EBELN", iMap.get("LEGACY_PO_NO"));

		JSONObject item = new JSONObject();

		item.put("ZDOC_NUM", iMap.get("KEY_1"));
		item.put("ZDOC_SEQ", iMap.get("KEY_2"));
		item.put("EBELP", iMap.get("LEGACY_PO_SEQ"));
		item.put("MATNR", iMap.get("BUYER_ITEM_NO"));
		item.put("MENGE", iMap.get("GR_QTY"));
		item.put("MEINS", iMap.get("UNIT_MEASURE"));

		JSONArray itItem = new JSONArray();
		itItem.add(item);

		root.put("IS_HEADER", isHeader);
		root.put("IT_ITEM", itItem);

		return root;
	}
	
	private JSONObject makeCancelJson(Map<String, Object> iMap) {
		JSONObject root = new JSONObject();

		JSONObject isHeader = new JSONObject();

		isHeader.put("BUDAT", iMap.get("GR_DATE"));
		isHeader.put("MJAHR", iMap.get("KEY_8"));
		isHeader.put("MBLNR", iMap.get("KEY_9"));

		JSONObject item = new JSONObject();

		item.put("ZDOC_NUM", iMap.get("KEY_1"));
		item.put("ZDOC_SEQ", iMap.get("KEY_2"));
		item.put("ZEILE", iMap.get("KEY_10"));

		JSONArray itItem = new JSONArray();
		itItem.add(item);

		root.put("IS_HEADER", isHeader);
		root.put("IT_ITEM", itItem);

		return root;
	}

}
