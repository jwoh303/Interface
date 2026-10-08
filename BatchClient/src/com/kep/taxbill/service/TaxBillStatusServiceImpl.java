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
import com.kep.taxbill.dao.TaxBillStatusDao;
import com.kep.taxbill.dao.TaxBillStatusDaoImpl;
import com.kep.taxbill.dao.TaxBillStatusKEPCONDao;
import com.kep.taxbill.dao.TaxBillStatusKEPCONDaoImpl;

@SuppressWarnings("unchecked")
public class TaxBillStatusServiceImpl implements TaxBillStatusService {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private TaxBillStatusDao dao	= new TaxBillStatusDaoImpl();
	private TaxBillStatusKEPCONDao daoKepCon	= new TaxBillStatusKEPCONDaoImpl();

	@Override
	public void executeBatch() {
		/**
		 * Tax Bill Status Check Batch....
		 * 1. select Search Condition
		 * 2. 
		 */

		// 기초세팅
		SimpleDateFormat dFormat = new SimpleDateFormat("yyyyMMddHHmmss");
		UpdateIfStatus_Dao if_dao = new UpdateIfStatus_DaoImpl();
		Map<String, String> bMap = new HashMap<String, String>();
		bMap.put("PGM_ID", this.getClass().getName());
		
		try {
			log.info("TaxBillStatusService Start...");

			// 시작시점
			Date sTime = new Date();
			bMap.put("JOB_SDATE", dFormat.format(sTime));
			
			List<Map<String, String>> iMaps = dao.selectRunCheck(bMap);
			
			for (Map<String, String> iMap : iMaps) {
				
				if ("Y".equals(iMap.get("RUN"))) {

					List<Map<String, String>> tbList	= dao.selectSearchCondition(iMap);

					// 데이터 건수 
					bMap.put("JOB_CNT", Integer.toString( tbList.size() ));
					
					String tax_url = "";

					for (Map<String, String> tMap : tbList) {
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("MessageId", 		tMap.get("MESSAGEID"));
						jsonObj.put("Signal", 			tMap.get("SIGNAL"));
						jsonObj.put("RequestTime", 		tMap.get("REQUESTTIME"));
						jsonObj.put("SendComRegno", 	tMap.get("SENDCOMREGNO"));
						jsonObj.put("AuthToken", 		tMap.get("AUTHTOKEN"));
						jsonObj.put("ServiceCode", 		tMap.get("SERVICECODE"));
						jsonObj.put("SearchFromDate", 	iMap.get("SEARCHFROMDATE"));
						jsonObj.put("SearchToDate", 	iMap.get("SEARCHTODATE"));
						jsonObj.put("SearchComRegno", 	tMap.get("SEARCHCOMREGNO"));
						jsonObj.put("RepoTypeCode", 	tMap.get("REPOTYPECODE"));
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
						log.info("Period["+tMap.get("SENDCOMREGNO")+"-"+tMap.get("REPOTYPECODE")+"] : " + iMap.get("SEARCHFROMDATE") + " ~ " + iMap.get("SEARCHTODATE"));
						log.debug("response="+response);
						
			            JSONParser jsonParser = new JSONParser();
			            
			            try {

				            JSONObject jsonResponse = (JSONObject) jsonParser.parse(response);
							
							if("30000".equalsIgnoreCase((String)jsonResponse.get("ResultCode"))){
								JSONObject jsonResultDataSet = (JSONObject) jsonResponse.get("ResultDataSet");
								JSONArray jsonArray = (JSONArray) jsonResultDataSet.get("Table");
								int totalCount = jsonArray.size();
								log.debug(" SENDCOMREGNO : " + tMap.get("SENDCOMREGNO") +" / SEARCHCOMREGNO : "+tMap.get("SEARCHCOMREGNO") +" ==> 결과건수 : "+ jsonArray.size());
								if (0 < totalCount) {
									for (int i = 0; i < totalCount; i++) {
										Map<String, String> pMap = (JSONObject) jsonArray.get(i);
										int rtnCnt = dao.updateTaxBillStatus(pMap);
										
										if (rtnCnt == 0) {
											rtnCnt = daoKepCon.updateTaxBillStatus(pMap);
											log.debug("KEPCON 처리대상 : ["+pMap.get("ETC_PCS_NO")+"]");
											log.debug("ResultCode : ["+(String)jsonResponse.get("ResultCode")+"]");
											log.debug("NTS_INFO : ["+pMap+"]");
										}
									}
								}
								else {
									log.info("데이터가 존재하지 않습니다. SENDCOMREGNO : " + tMap.get("SENDCOMREGNO") +" / SEARCHCOMREGNO : "+tMap.get("SEARCHCOMREGNO"));
								}
							}
							else{
								log.error((String)jsonResponse.get("ResultMessage"));
							}
						} catch (Exception e) {
							log.error(this.getClass().getName() + " Json Parsing Error : " + CommonUtil.printStackTraceToString(e));
						}
					}
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
		log.info("TaxBillStatusService Finish...");
	}

}
