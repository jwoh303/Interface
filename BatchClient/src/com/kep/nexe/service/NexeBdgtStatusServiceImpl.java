package com.kep.nexe.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Base64;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.nexe.dao.BdgtSubmitDao;
import com.kep.nexe.dao.BdgtSubmitDaoImpl;

public class NexeBdgtStatusServiceImpl implements NexeBdgtStatusService {

	private Logger log = Logger.getLogger(this.getClass().getName());
	
	@Override
	public void execute() throws Exception {
		BdgtSubmitDao dao = new BdgtSubmitDaoImpl(); 
		
		//BASIC 인증
		String basicKey = Base64.getEncoder().encodeToString(("paranoid:survive").getBytes());	
		String apiUrl = CommonProperty.getNEXE_URL() + "1005_KEP_MM_S/Request";
		
		HttpURLConnection httpUrlConn = null;
		
		List<Map<String, String>> AccountCdList = dao.selectNexeAccountCdList();
		
		Calendar cal = Calendar.getInstance();
		int year = cal.get(Calendar.YEAR);
		int month = cal.get(Calendar.MONTH) + 1;
		
		if (AccountCdList != null && AccountCdList.size() > 0) {
			for (Map<String, String> iMap : AccountCdList) {
				try {
					
					URL url = new URL(apiUrl);
					httpUrlConn = (HttpURLConnection) url.openConnection();
					httpUrlConn.setRequestMethod("POST");
					httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
					httpUrlConn.setRequestProperty("Authorization", "Basic " + basicKey);
					httpUrlConn.setDoOutput(true);
					httpUrlConn.setDoInput(true); 
					httpUrlConn.setRequestProperty("Accept", "application/json");
					
					JSONArray ZKEP_BDGT = new JSONArray();
					JSONObject jsonObj2 = new JSONObject();
					JSONObject jsonObj3 = new JSONObject();
					
					JSONObject jsonObj = new JSONObject();
					if ("5".contentEquals(CommonProperty.getDB_CONN())) {
						jsonObj.put("BUYER","CZ10");           					 //체코
					}else if ("6".contentEquals(CommonProperty.getDB_CONN())) {
						jsonObj.put("BUYER","CZ10");           					 //체코 임시
					}else if ("7".contentEquals(CommonProperty.getDB_CONN()) || "8".contentEquals(CommonProperty.getDB_CONN())) {
						jsonObj.put("BUYER","CN10");           					 //중국
					}else {
						jsonObj.put("BUYER","KR10");           					 //국내
					}
					jsonObj.put("TERM_YEAR",Integer.toString(year));
					if(Integer.toString(month).length() == 1) {
						jsonObj.put("TERM_MONTH","0"+Integer.toString(month));
					}else {
						jsonObj.put("TERM_MONTH",Integer.toString(month));
					}
					jsonObj.put("ACCOUNT_CD",iMap.get("CODE"));
					jsonObj.put("DEPT_CD","");
					jsonObj.put("CURRENCY","");
					jsonObj.put("PLAN_AMT","");
					jsonObj.put("BALANCE_AMT","");
					jsonObj.put("DEPT_NM","");
					jsonObj.put("ACCOUNT_NM","");
					
					ZKEP_BDGT.add(jsonObj);
					
					jsonObj2.put("ZKEP_BDGT",ZKEP_BDGT);
					jsonObj3.put("Request",jsonObj2);

					OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(),"utf-8");
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
						JSONArray resultBudgetArray = (JSONArray)resultObj2.get("ZKEP_BDGT");
						
						int BudgetCount = resultBudgetArray.size();
						if (0 < BudgetCount) {
							for( int i = 0 ; i < BudgetCount ; i++ ) {
								JSONObject iObj = (JSONObject)resultBudgetArray.get(i);
								Map<String, Object> resultMap = new HashMap<String, Object>();
								log.info("iObj RESULT !!!!" + iObj);
								resultMap.put("BUYER", iObj.get("BUYER"));
								resultMap.put("TERM_YEAR", iObj.get("TERM_YEAR"));
								resultMap.put("TERM_MONTH", iObj.get("TERM_MONTH"));
								resultMap.put("DEPT_CD", iObj.get("DEPT_CD"));
								resultMap.put("ACCOUNT_CD", iObj.get("ACCOUNT_CD"));
								resultMap.put("CURRENCY", iObj.get("CURRENCY"));
								resultMap.put("PLAN_AMT", iObj.get("PLAN_AMT"));
								resultMap.put("BALANCE_AMT", iObj.get("BALANCE_AMT"));
								resultMap.put("DEPT_NM", iObj.get("DEPT_NM"));
								resultMap.put("ACCOUNT_NM", iObj.get("ACCOUNT_NM"));
								
								dao.insertNexeBudget(resultMap);
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
					}
				}catch (Exception e) {
					e.printStackTrace();
					log.error("execute Error : " + e.getMessage());
				}finally {
					httpUrlConn.disconnect();
				}
			}
		}	
	}
}
