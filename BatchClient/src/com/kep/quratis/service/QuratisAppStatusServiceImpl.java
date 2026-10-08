package com.kep.quratis.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.quratis.dao.AppStatusDao;
import com.kep.quratis.dao.AppStatusDaoImpl;

import hdli.cs.ws.server.T_APPR_STATUS_IN_STEP;
import hdli.cs.ws.server.T_APPR_STATUS_LIST_CALL;
import hdli.cs.ws.server.WSKP002WebServiceProxy;

public class QuratisAppStatusServiceImpl implements QuratisAppStatusService{
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	@Override
	public void execute() {
		
		AppStatusDao dao = new AppStatusDaoImpl();

		String st_url = "https://api.hiworks.com/approval/v2/documents/";
		String authorization = "38a88cc0443d8b973ef4b97095fe7d00";
		
		try {

			List<Map<String, String>> pIdList	= dao.getAppList();
			int size = pIdList.size();
			
			if (size > 0) {
				
				for (Map<String, String> iMap : pIdList) {
					
					URL url = new URL(st_url+iMap.get("KEY_2"));
					HttpsURLConnection con = (HttpsURLConnection)url.openConnection();

					con.setRequestMethod("GET");
					con.setRequestProperty("Content-Type", "application/json; utf-8");
					con.setRequestProperty("Accept", "application/json;");
					con.setRequestProperty ("Authorization", "Bearer " + authorization);
					con.setDoOutput(true);
					con.setDoInput(true);
					con.setUseCaches(false);
					con.connect();
					
					BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
					StringBuilder response = new StringBuilder();
					String responseLine = null;
					while ((responseLine = br.readLine()) != null ) {
						response.append(responseLine.trim());
					}
					
					//response : {"data":{"type":"documents","id":"1251190","attributes":{"state":"complete"}}}
					
					JSONParser parser = new JSONParser(); 
					Object obj = parser.parse( response.toString()); 
					JSONObject jsonObj = (JSONObject) obj;
					JSONObject jsonObj1 = (JSONObject) jsonObj.get("data");
					JSONObject jsonObj2 = (JSONObject) jsonObj1.get("attributes");
					
					System.out.println("11 : " + jsonObj1.get("id"));
					System.out.println("22 : " + jsonObj2.get("state"));
					
					iMap.put("id", (String)jsonObj1.get("id"));
					iMap.put("state", (String)jsonObj2.get("state"));
					
					dao.UpdateAppStatus(iMap);
					
				}
				
			}
			
		} catch (Exception e) {
			log.error("AppStatusService Error : " + CommonUtil.printStackTraceToString(e));
			System.out.println(CommonUtil.printStackTraceToString(e));
		}
	}
}
