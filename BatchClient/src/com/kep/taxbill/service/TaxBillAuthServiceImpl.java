package com.kep.taxbill.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.common.dao.UpdateIfStatus_Dao;
import com.kep.common.dao.UpdateIfStatus_DaoImpl;
import com.kep.taxbill.dao.TaxBillAuthDao;
import com.kep.taxbill.dao.TaxBillAuthDaoImpl;

@SuppressWarnings("unchecked")
public class TaxBillAuthServiceImpl implements TaxBillAuthService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void executeBatch() {
		
		TaxBillAuthDao dao	= new TaxBillAuthDaoImpl();

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			log.info("TaxBillAuthService Start...");

			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			List<Map<String, String>> tbList	= dao.selectTaxBillAuth();

			// 데이터 건수 
			bMap.put("JOB_CNT", Integer.toString( tbList.size() ));
			
			String tax_url = "";
			
			for (Map<String, String> tMap : tbList) {
				JSONObject jsonObj = new JSONObject();
				jsonObj.put("MessageId", tMap.get("MESSAGEID"));
				jsonObj.put("Signal", tMap.get("SIGNAL"));
				jsonObj.put("RequestTime", tMap.get("REQUESTTIME"));
				jsonObj.put("SendComRegno", tMap.get("SENDCOMREGNO"));
				jsonObj.put("AuthCode", tMap.get("AUTHCODE"));
				jsonObj.put("SbId", tMap.get("SBID"));
				jsonObj.put("ExpirationDateCode", tMap.get("EXPIRATIONDATECODE"));
				jsonObj.put("ExpirationDate", tMap.get("EXPIRATIONDATE"));
				jsonObj.put("RepoTypeCode", tMap.get("REPOTYPECODE"));
				if ( "2".equals(CommonProperty.getDB_CONN()) ) {
					tax_url = "https://api.smartbill.co.kr/sb-api/request/";
				} else {
					tax_url = "https://demoapi.smartbill.co.kr/sb-api/request/";
				}
				URL url = new URL(tax_url);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("POST");
				conn.setUseCaches(false);
				conn.setDoInput(true);
				conn.setDoOutput(true);
				conn.setConnectTimeout(10000);
				conn.setRequestProperty("Content-Type", "application/json");
				conn.setRequestProperty("Accept", "application/json");
				DataOutputStream os = new DataOutputStream(conn.getOutputStream());
				os.write(jsonObj.toString().getBytes());
				os.flush();
				os.close();
				
				BufferedReader br;
				String response = "";
				if(null != conn){
					br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
					String line = null;
					while((line = br.readLine()) != null){
						response += line + "\n";
					}
				}
				
	            JSONParser jsonParser = new JSONParser();
	            JSONObject jsonResponse = (JSONObject) jsonParser.parse(response);
	            
				if("30000".equalsIgnoreCase((String)jsonResponse.get("ResultCode"))){
					JSONObject jsonResultDataSet = (JSONObject) jsonResponse.get("ResultDataSet");
					JSONArray jsonArray = (JSONArray) jsonResultDataSet.get("Table1");
					JSONObject jsonTable = (JSONObject)jsonArray.get(0);
					
					Map<String, String> pMap	= new HashMap<String, String>();
					pMap.put("AUTH_TOKEN", 		jsonTable.get("AUTH_TOKEN").toString());
					pMap.put("SENDCOMREGNO", 	tMap.get("SENDCOMREGNO"));
					pMap.put("FND_USER", 		tMap.get("FND_USER"));
					
					dao.updateTaxBillAuth(pMap);
				} else{
					log.error(jsonResponse.get("ResultMessage"));
				}
			}
		} catch (Exception e) {
			log.error(this.getClass().getName() + " Error : " + CommonUtil.printStackTraceToString(e));
		} finally {
			// 종료시점
			Date eTime = new Date();
			bMap.put("JOB_EDATE", dFormat.format(eTime));
			if_dao.insertMroJobDate(bMap);
		}
		log.info("TaxBillAuthService Finish...");
	}
}
