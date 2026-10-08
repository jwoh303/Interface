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
import com.kep.nexe.dao.GrSubmitDao;
import com.kep.nexe.dao.GrSubmitDaoImpl;

public class NexeGrSubmitServiceImpl implements NexeGrSubmitService {

	private Logger log = Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() throws Exception {
		GrSubmitDao dao = new GrSubmitDaoImpl();
		
		//BASIC 인증
		String basicKey = Base64.getEncoder().encodeToString(("paranoid:survive").getBytes());	
		String apiUrl =  CommonProperty.getNEXE_URL() + "1003_KEP_MM_S/Request";
		
		HttpURLConnection httpUrlConn = null;
		
		//대상 조회
		List<Map<String,String>> map = dao.selectGrTargetList();
		
		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				List<Map<String,String>> pMaps = dao.selectGrList(map.get(i));
				JSONArray ZKEP_GR = new JSONArray();
				JSONObject jsonObj2 = new JSONObject();
				JSONObject jsonObj3 = new JSONObject();
				Map<String, String> resultMap	= 	new HashMap<String, String>();
				
				int size = pMaps.size();
				
				try {
					if(size > 0) {
						for (Map<String, String> iMap : pMaps) {
							resultMap = map.get(i);
							JSONObject jsonObj = new JSONObject();
							jsonObj.put("INV_NO",iMap.get("KEY_2"));
							jsonObj.put("INV_SEQ",iMap.get("INV_SEQ"));
							if ("5".contentEquals(CommonProperty.getDB_CONN())) {
								jsonObj.put("BUKRS","CZ10");           					 //체코
							}else if ("7".contentEquals(CommonProperty.getDB_CONN()) || "8".contentEquals(CommonProperty.getDB_CONN())) {
								jsonObj.put("BUKRS","CN10");           					 //중국
							}else {
								jsonObj.put("BUKRS","KR10");           					 //국내
							}
							jsonObj.put("ZSTATUS",iMap.get("ZSTATUS"));
							jsonObj.put("PLANT", iMap.get("PLANT"));
							jsonObj.put("INV_DATE",iMap.get("INV_DATE"));
							jsonObj.put("LEGACY_PO_NO",iMap.get("LEGACY_PO_NO"));
							jsonObj.put("LEGACY_PO_SEQ",iMap.get("LEGACY_PO_SEQ"));
							jsonObj.put("BUYER_ITEM_NO",iMap.get("BUYER_ITEM_NO"));
							jsonObj.put("INV_QTY",iMap.get("INV_QTY"));
							jsonObj.put("UNIT_MEASURE",iMap.get("UNIT_MEASURE"));
							if("D".equals(iMap.get("ZSTATUS")) && iMap.get("SMBLN") != null) {
								jsonObj.put("SMBLN",iMap.get("SMBLN"));
								jsonObj.put("SJAHR",iMap.get("SJAHR"));
								jsonObj.put("SMBLP",iMap.get("SMBLP"));
							}else {
								jsonObj.put("SMBLN","");
								jsonObj.put("SJAHR","");
								jsonObj.put("SMBLP","");
							}
							jsonObj.put("MBLNR","");
							jsonObj.put("MJAHR","");
							jsonObj.put("ZEILE","");
							jsonObj.put("IF_FLAG","");
							jsonObj.put("IF_MSG","");
							ZKEP_GR.add(jsonObj);
						}
					
						jsonObj2.put("ZKEP_GR",ZKEP_GR);
						jsonObj3.put("Request",jsonObj2);
						
						URL url = new URL(apiUrl);
						httpUrlConn = (HttpURLConnection) url.openConnection();
						httpUrlConn.setRequestMethod("POST");
						httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
						httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
						httpUrlConn.setDoOutput(true);
						httpUrlConn.setDoInput(true); 
						httpUrlConn.setRequestProperty("Accept", "application/json");
						
				
						OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(),"utf-8");
						wr.write(jsonObj3.toString());
						wr.flush();
						wr.close();
						
						StringBuilder sb = new StringBuilder();
						if (httpUrlConn.getResponseCode() == HttpURLConnection.HTTP_OK) {
							log.info("RESULT HTTP_OK HTTP_OK!HTTP_OK!!!" +httpUrlConn.getResponseCode());
							
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
							JSONArray resultArray = (JSONArray)resultObj2.get("ZKEP_GR");
	
							for (int j = 0; j < resultArray.size(); j++) {
								JSONObject resultArrayObj = (JSONObject) resultArray.get(j);
								resultMap.put("KEYFLAG", "N");
								if("S".equals((String)resultArrayObj.get("IF_FLAG"))) {
									resultMap.put("FLAG", "Y");
								}else {
									resultMap.put("FLAG", "E");
								}
								resultMap.put("IF_MSG", (String) resultArrayObj.get("IF_MSG"));
								resultMap.put("GR_NO", (String) resultArrayObj.get("INV_NO"));
								resultMap.put("GR_SEQ", (String) resultArrayObj.get("INV_SEQ"));
								resultMap.put("STATUS", (String) resultArrayObj.get("ZSTATUS"));
								if("C".equals((String) resultArrayObj.get("ZSTATUS")) && "S".equals((String)resultArrayObj.get("IF_FLAG"))){
									resultMap.put("KEYFLAG", "Y");
									resultMap.put("MBLNR", (String) resultArrayObj.get("MBLNR"));
									resultMap.put("MJAHR", (String) resultArrayObj.get("MJAHR"));
									resultMap.put("ZEILE", (String) resultArrayObj.get("ZEILE"));
								}
								
								log.info("resultArrayObj resultArrayObj !!!!" + resultArrayObj);
								log.info("resultMap resultMap !!!!" + resultMap);
								dao.updateNexeGrResult(resultMap);
							}
						
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
					}
				} catch (Exception e) {
					e.printStackTrace();
					log.error("execute Error : " + e.getMessage());
				}
				
			}
		}
	}

}
