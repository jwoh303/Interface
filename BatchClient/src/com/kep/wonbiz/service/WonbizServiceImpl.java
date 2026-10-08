package com.kep.wonbiz.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.kep.wonbiz.dao.WonbizDao;
import com.kep.wonbiz.dao.WonbizDaoImpl;

public class WonbizServiceImpl implements WonbizService {

	private Logger log	= Logger.getLogger( this.getClass() );

	@Override
	public void execute() throws Exception{
		
		String access_token = "";
		//String tokenApiURL = "https://dbaasapi.wooribank.com/oai/wb/v1/emp/getTransListInfo"; 개발
		//String appKey = "l7xx936da8497a1344e5a53f0acb1ceb38ee"; 개발
		
		String tokenApiURL = "https://baasapi.wooribank.com/oai/wb/v1/emp/getTransListInfo";
		String appKey = "l7xx5f4bf41cdbbe4168b12283ce80474e4d";  
		
		WonbizDao dao = new WonbizDaoImpl(); 
		  
        HttpURLConnection httpUrlConn = null;

        List<Map<String,Object>> map = dao.selectWonbizTargetList();
		int size = map.size();	
        
		if (size > 0) {
			for (Map<String, Object> iMap : map) {
		        String flag = "E";
		        String errMsg = "";
				
				try {
		        	JSONObject root = new JSONObject();
		        	
		        	JSONObject dateHeader = new JSONObject();
		        	dateHeader.put("PARTNER_CODE", "8MOPN060"); //파트너 코드
		        	
		        	JSONObject dataBody = new JSONObject();
		        	dataBody.put("LNKD_PLTF_MD_ID", "BASER0000010_KP01_TRND_API"); //연계플랫폼매체 ID
		        	dataBody.put("GRID_ROW_CNT", 1); //그리드 연결 수 
		        	
		        	JSONArray dataGridArr = new JSONArray();
		        	JSONObject dataGrid = new JSONObject();
		        		
		        	dataGrid.put("TRN_DATA_ID", iMap.get("KEP_PO_NO")); 		//거래자료ID
		        	dataGrid.put("MMBHC_SQ", iMap.get("REVISION"));  //회차 
		        	dataGrid.put("BUYR_BZNO", iMap.get("KEP_IRS"));     	 	//구매사사업자번호
		        	dataGrid.put("SPLR_BZNO", iMap.get("AGENT_IRS"));           //공급사사업자번호 
		        	dataGrid.put("MMBHC_TRN_DATA_NO", iMap.get("KEP_PO_NO"));   //거래자료번호
		        	dataGrid.put("MMBHC_TRN_DATA_NM", iMap.get("SUBJECT"));   	//거래자료명 
		        	dataGrid.put("TOT_TRN_AM", iMap.get("VAT_TOT_AMT"));        //총거래금액
		        	dataGrid.put("VAT",  iMap.get("VAT_AMT"));					//부가세
		        	dataGrid.put("SPL_AM", iMap.get("AGENT_ITEM_AMT"));			//공급금액
		        	dataGrid.put("DLPR_DT", iMap.get("CLOSE_DATE"));			//납품일자  iMap.get("DS_DATE") -> 유효종료일자로 변경
		        	dataGrid.put("DMS_RPRS_ITEM_NM",iMap.get("DESCRIPTION"));   //대표품목명
		        	dataGrid.put("RMRK_TXT",iMap.get("DESCRIPTION"));           //비고내용
		        	dataGrid.put("DMS_TRN_TYCD",iMap.get("JOB_TYPE"));			//거래유형코드  01발주, 02 계약
		        	dataGrid.put("VLD_STA_DT",iMap.get("START_DATE"));          //유효시작일
		        	dataGrid.put("VLD_END_DT",iMap.get("CLOSE_DATE"));			//유효종료일자
		        	dataGrid.put("DMS_TRN_STCD",iMap.get("JOB_STATUS"));     	//거래상태코드  10승인, 20해지
		        	
		        	dataGridArr.add(dataGrid);
		        	
		        	dataBody.put("GRID", dataGridArr);
		
					/*root.put("dataHeader", dateHeader);
					root.put("dataBody", dataBody);*/
		        	
		        	ObjectMapper mapper = new ObjectMapper();
		        	
		        	Map<String,Object> rootMap = new LinkedHashMap<>();
		        	rootMap.put("dataHeader", dateHeader);
		        	rootMap.put("dataBody", dataBody);
		        	
		        	String json = mapper.writeValueAsString(rootMap);
		        	
		            log.info("json" + json);
		
		            URL url = new URL(tokenApiURL);
		            httpUrlConn = (HttpURLConnection) url.openConnection();
		
		            httpUrlConn.setRequestMethod("POST");
		            httpUrlConn.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
		            httpUrlConn.setRequestProperty("appKey", appKey);
		
		            httpUrlConn.setDoInput(true);
		            httpUrlConn.setDoOutput(true);
		
		            httpUrlConn.setConnectTimeout(60000);
		            httpUrlConn.setReadTimeout(60000);
		
		            // Body 없음
		            OutputStreamWriter wr = new OutputStreamWriter(httpUrlConn.getOutputStream(), "UTF-8");
		            wr.write(json);
		            wr.flush();
		            wr.close();
		
		            int responseCode = httpUrlConn.getResponseCode();
		
		            log.info("root.toString() = " + root.toString());
		            log.info("responseCode = " + responseCode);
		
		            BufferedReader br = null;
		            if (responseCode >= 400) {
		                br = new BufferedReader(new InputStreamReader(httpUrlConn.getErrorStream(),"UTF-8"));
		            } else {
		                br = new BufferedReader(new InputStreamReader(httpUrlConn.getInputStream(),"UTF-8"));
		            }
		            
		            StringBuilder sb = new StringBuilder();
		            String line = null;
		            while ((line = br.readLine()) != null) {sb.append(line);}
		            br.close();
		            if (responseCode == 200) {
		                JSONParser parser = new JSONParser();
		                JSONObject jsonResponse = (JSONObject) parser.parse(sb.toString());
		                log.info("jsonResponse = " + jsonResponse.toString());
		                JSONObject responseDataBody = (JSONObject) jsonResponse.get("dataBody");
		                String rtcd = String.valueOf(responseDataBody.get("RTCD"));

		                if ("1000".equals(rtcd)) {
		                	flag = "Y";
		                } else {
		                	flag = "E";
		                    errMsg = String.valueOf(responseDataBody.get("RSMSG"));
		                    JSONArray grid = (JSONArray) responseDataBody.get("GRID");
		                    
		                    if(grid != null && !grid.isEmpty()) {
		                    	 JSONObject errObj = (JSONObject) grid.get(0);
				                 if (errObj.get("RSN") != null) {
				                	 errMsg += " / " + errObj.get("RSN").toString();
				                 }
		                    }
		                }
		            } else {
		            	flag = "E";
		                errMsg = "HTTP ERROR : " + responseCode + " / 통신오류";
		                log.info("sb.toString()" + sb.toString());
		            }
		        } catch (Exception e) {
		            flag = "E";
		            errMsg = "통신오류";
		            log.info("getAccesTokenAPI Error", e);

		        } finally {
		            if (httpUrlConn != null) {
		                httpUrlConn.disconnect();
		            }
		            try {
		            	 iMap.put("flag", flag);
			             iMap.put("errMsg", errMsg);
			             dao.updateSubmitResult(iMap);
					} catch (Exception e2) {
						log.info("updateSubmitResult Error", e2);
					}
		        }
			}
			
		}

	}

}
