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
import com.kep.nexe.dao.PoStatusDao;
import com.kep.nexe.dao.PoStatusDaoImpl;
import com.kep.nexe.dao.PrSubmitDao;
import com.kep.nexe.dao.PrSubmitDaoImpl;

public class NexePOStatusServiceImpl implements NexePOStatusService {

	private Logger log = Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() throws Exception{
		PoStatusDao dao = new PoStatusDaoImpl();
		
		//BASIC 인증
		String basicKey = Base64.getEncoder().encodeToString(("paranoid:survive").getBytes());	
		String apiUrl =  CommonProperty.getNEXE_URL() + "1004_KEP_MM_S/Request";
		
		HttpURLConnection httpUrlConn = null;
		
		List<Map<String, String>> map = dao.selectPoSatusTargetList();
		
		if (map != null && map.size() > 0) {
			for (int i = 0; i < map.size(); i++) {
				Map<String, String> resultMap = map.get(i);
				resultMap.put("DOC_TYPE", "PO");
				try {
					URL url = new URL(apiUrl);
					httpUrlConn = (HttpURLConnection) url.openConnection();
					httpUrlConn.setRequestMethod("POST");
					httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
					httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
					httpUrlConn.setDoOutput(true);
					httpUrlConn.setDoInput(true); 
					httpUrlConn.setRequestProperty("Accept", "application/json");
					httpUrlConn.setConnectTimeout(10000);
					
					JSONObject jsonObj = new JSONObject();
					JSONObject jsonObj2 = new JSONObject();
					jsonObj.put("PR_NO", map.get(i).get("BUYER") + map.get(i).get("PR_NO"));
					jsonObj.put("PR_SEQ", map.get(i).get("PR_SEQ"));
					
					jsonObj2.put("Request",jsonObj);

					OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "utf-8");
					wr.write(jsonObj2.toString());
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
						JSONArray resultArray = (JSONArray)resultObj2.get("ZKEP_PO_R");
						httpUrlConn.disconnect();
						
						log.info("jsonResponse RESULT !!!!" + jsonResponse.toString());
						log.info("resultMap !!!!" + resultMap);
						
						for (int j = 0; j < resultArray.size(); j++) {
							JSONObject resultArrayObj = (JSONObject) resultArray.get(j);
							if((String)resultArrayObj.get("FRGKE") != null && "2".equals((String)resultArrayObj.get("FRGKE"))) {
								resultMap.put("LEGACY_PO_NO", (String)resultArrayObj.get("LEGACY_PO_NO"));
								resultMap.put("LEGACY_PO_SEQ", (String)resultArrayObj.get("LEGACY_PO_SEQ"));
								resultMap.put("FLAG", (String)resultObj2.get("IF_FLAG"));
								resultMap.put("IF_FLAG", "Y");
								
								dao.updateNexePoResult(resultMap);
								dao.insertNexePoResult(resultMap);
							}else if((String)resultArrayObj.get("ZSTATUS") != null && "20".equals((String)resultArrayObj.get("ZSTATUS")) && (String)resultArrayObj.get("LEGACY_PO_NO") == null) {
								log.info("ZSTATUS 20202020 !!!!");
								
								resultMap.put("FLAG", (String)resultArrayObj.get("ZSTATUS"));
								resultMap.put("IF_FLAG", "Y");
								
								dao.updateNexePoDelete(resultMap);
								dao.insertNexePoDelete(resultMap);
							}
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
						httpUrlConn.disconnect();
					}
				} catch (Exception e) {
					e.printStackTrace();
					log.error("execute Error : " + e.getMessage());
				}
			}
		}	
		if ("5".contentEquals(CommonProperty.getDB_CONN())) {
			dao.execNexePoStatus();
		}
	}

}
