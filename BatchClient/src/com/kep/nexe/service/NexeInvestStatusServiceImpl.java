package com.kep.nexe.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.nexe.dao.InvestStatusDao;
import com.kep.nexe.dao.InvestStatusDaoImpl;

public class NexeInvestStatusServiceImpl implements NexeInvestStatusService {

	private Logger log = Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() throws Exception {
		InvestStatusDao dao = new InvestStatusDaoImpl();
		
		//BASIC 인증
		String basicKey = Base64.getEncoder().encodeToString(("paranoid:survive").getBytes());	
		String apiUrl =  CommonProperty.getNEXE_URL() + "1006_KEP_MM_S/Request";
		
		HttpURLConnection httpUrlConn = null;
		
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		
		try {
			URL url = new URL(apiUrl);
			httpUrlConn = (HttpURLConnection) url.openConnection();
			httpUrlConn.setRequestMethod("POST");
			httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
			httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
			httpUrlConn.setDoOutput(true);
			httpUrlConn.setDoInput(true); 
			httpUrlConn.setRequestProperty("Accept", "application/json");
			
			JSONObject jsonObj = new JSONObject();
			JSONObject jsonObj2 = new JSONObject();
			
			if ("5".contentEquals(CommonProperty.getDB_CONN())) {
				jsonObj.put("BUKRS","CZ10");           					 //체코
			}else if ("7".contentEquals(CommonProperty.getDB_CONN()) || "8".contentEquals(CommonProperty.getDB_CONN())) {
				jsonObj.put("BUKRS","CN10");           					 //중국
			}else {
				jsonObj.put("BUKRS","KR10");           					 //국내
			}
			jsonObj.put("GJAHR",Integer.toString(year));
			if(Integer.toString(month).length() == 1) {
				jsonObj.put("PERBL","00"+Integer.toString(month));
			}else {
				jsonObj.put("PERBL","0"+Integer.toString(month));
			}
			jsonObj2.put("Request",jsonObj);

			OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(),"utf-8");
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
				JSONArray resultBudgetArray = (JSONArray)resultObj2.get("ZMMS20130_TX");
				JSONArray resultAssetArray = (JSONArray)resultObj2.get("ZMMS20131_TX");

				int BudgetCount = resultBudgetArray.size();
				int AssetCount = resultAssetArray.size();
				if (0 < BudgetCount) {
					for( int i = 0 ; i < BudgetCount ; i++ ) {
						JSONObject iObj = (JSONObject)resultBudgetArray.get(i);
						Map<String, Object> iMap = new HashMap<String, Object>();
						
						iMap.put("BUKRS",iObj.get("BUKRS"));
						iMap.put("GJAHR",Integer.toString(year));
						if(Integer.toString(month).length() == 1) {
							iMap.put("PERBL","0"+Integer.toString(month));
						}else {
							iMap.put("PERBL",Integer.toString(month));
						}
						iMap.put("CUR",iObj.get("CUR"));
						iMap.put("INVESTCD",iObj.get("INVESTCD"));
						iMap.put("INVESTNM",iObj.get("INVESTNM"));
						iMap.put("WKGAVA",iObj.get("WKGAVA"));
						
						dao.insertNexeInvestBudget(iMap);
					}
				}
				
				if (0 < AssetCount) {
					for( int j = 0 ; j < AssetCount ; j++ ) {
						JSONObject jObj = (JSONObject)resultAssetArray.get(j);
						Map<String, Object> jMap = new HashMap<String, Object>();
						
						jMap.put("BUKRS",jObj.get("BUKRS"));
						jMap.put("GJAHR",Integer.toString(year));
						if(Integer.toString(month).length() == 1) {
							jMap.put("PERBL","0"+Integer.toString(month));
						}else {
							jMap.put("PERBL",Integer.toString(month));
						}
						jMap.put("INVESTCD",jObj.get("INVESTCD"));
						jMap.put("ASSETCD",jObj.get("ASSETCD"));
						jMap.put("ASSETSUBNO",jObj.get("ASSETSUBNO"));
						jMap.put("ASSETNOTE",jObj.get("ASSETNOTE"));

						dao.insertNexeInvestAsset(jMap);
					}
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
		} catch (Exception e) {
			e.printStackTrace();
			log.error("execute Error : " + e.getMessage());
		}
	}

}
