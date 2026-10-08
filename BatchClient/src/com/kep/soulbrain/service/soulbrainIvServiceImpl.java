package com.kep.soulbrain.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.soulbrain.dao.soulbrainIvDao;
import com.kep.soulbrain.dao.soulbrainIvDaoImpl;
import com.kep.soulbrain.dao.soulbrainMsdsDao;
import com.kep.soulbrain.dao.soulbrainMsdsDaoImpl;

public class soulbrainIvServiceImpl implements soulbrainIvService {

	private Logger log = Logger.getLogger(this.getClass());
	
	@Override
	public void execute() throws Exception {
		String boundary  =  "----testboundarytestboundary";
	    String crlf = "\r\n";
	    String twoHyphens = "--";
		
		soulbrainIvDao dao = new soulbrainIvDaoImpl();
		soulbrainMsdsDao dao2 = new soulbrainMsdsDaoImpl(); 
		//String apiUrl = "http://10.11.17.22/sendSRMStorageNo2.so";  개발
		String apiUrl = "https://srm.soulbrain.co.kr/sendSRMStorageNo2.so";
		String resultMeg = "";
		Map<String, String> resultData = new HashMap<String, String>();
		
		try {
			//대상 조회
			List<Map<String,String>> map = dao.selectTargetHdList();
			
			if (map != null && map.size() > 0) {
				for (int j = 0; j < map.size(); j++) {
					resultMeg = "";
					log.info("map.get(j)map.get(j)map.get(j) !!!!!!!!!!!!!!!!!" +map.get(j));
					List<Map<String,String>> listMap = dao.selectTargetDtList(map.get(j));
					Map<String, String> resultMap = new HashMap<String, String>();
					resultData.put("BUYER", map.get(j).get("BUYER"));
					resultData.put("INV_NO", map.get(j).get("INV_NO"));
					resultMap.put("BUYER", map.get(j).get("BUYER")); 
					resultMap.put("INV_NO", map.get(j).get("INV_NO")); 
					
					int cnt = 0;
					int size = listMap.size();
					if(size > 0) {
						JSONArray formFieldArry = new JSONArray();
						String sInvcCd ="";
						
						for ( Map<String,String> iMap : listMap) {
							JSONObject formField	= new JSONObject();	
							formField.put("BIZ_INV_NUM", iMap.get("BUYER")+iMap.get("INV_NO"));
							formField.put("BIZ_INV_SQ", iMap.get("INV_SEQ"));
							formField.put("PO_NO", iMap.get("LEGACY_PO_NO"));
							formField.put("PO_LINE_LN", iMap.get("LEGACY_PO_SEQ"));
							formField.put("GR_QTY", iMap.get("ITEM_QTY"));
							formField.put("GR_DT", iMap.get("INV_DATE"));
							formFieldArry.add(formField);
						}
						log.info("formFieldArry.toString() !!!!!!!!!!!!!!!!!" +formFieldArry);
						
						String appStr	= formFieldArry.toJSONString();  
						URL url = new URL(apiUrl);
						HttpURLConnection httpConn = (HttpURLConnection)url.openConnection();
						httpConn.setUseCaches(false);
						httpConn.setDoOutput(true);
						httpConn.setDoInput(true);
						httpConn.setRequestMethod("POST");
						httpConn.setRequestProperty("Connection", "Keep-Alive");
						httpConn.setRequestProperty("Cache-Control", "no-cache");
						httpConn.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);
						httpConn.setConnectTimeout(10000);
						
						StringBuilder sb = new StringBuilder();
						sb.append(twoHyphens + boundary + crlf);
						sb.append("Content-Disposition: form-data; name=\"ITEMLIST\"").append(crlf);
						sb.append(crlf).append(appStr).append(crlf);
						sb.append(twoHyphens + boundary + twoHyphens);
						OutputStream os = httpConn.getOutputStream();
						
						log.info("sb.toString() !!!!!!!!!!!!!!!!!" +sb);
						os.write(sb.toString().getBytes("utf-8"));
						os.flush();
						os.close();
						
						BufferedReader responseStreamReader = new BufferedReader(new InputStreamReader(httpConn.getInputStream(), "utf-8"));
						String line = "";
						StringBuilder stringBuilder = new StringBuilder();
						while ((line = responseStreamReader.readLine()) != null) {
						    stringBuilder.append(line).append("\n");
						}
						responseStreamReader.close();
						
						resultMeg = map.get(j).get("BUYER") +"/"+ map.get(j).get("INV_NO") +"/"+ stringBuilder.toString();
						
						JSONParser parser = new JSONParser(); 
						log.info("stringBuilder.toString() !!!!!!!!!!!!!!!!!" +stringBuilder.toString());
						Object obj = parser.parse(stringBuilder.toString()); 
						JSONObject jsonObj = (JSONObject) obj;
						JSONArray jsonArray = (JSONArray)jsonObj.get("GRLIST");
						JSONObject jsonTable = (JSONObject)jsonArray.get(0);
						sInvcCd = jsonTable.get("S_INVC_CD").toString();

						log.info("sInvcCd !!!!!!!!!!!!!!!!!" +sInvcCd);
						if(!"".equals(sInvcCd)) {
							resultMap.put("sInvcCd", sInvcCd); 
							resultMap.put("FLAG", "Y");
							dao.updateIvResult(resultMap);
							dao.saveIvResult(resultMap);
						}else {
							resultMap.put("FLAG", "E");
							dao.updateIvResult(resultMap);
						}
					}
				}
			}
					
		} catch (Exception e) {
			try {
				resultData.put("INTERFACE_ID", "soulbrainIvServiceImpl");
				resultData.put("CONTENTS", resultMeg);
				resultData.put("FLAG", "E");
				resultData.put("ERROR_MSG", e.getMessage());
				dao2.saveErrLog(resultData);
				dao.updateIvResult(resultData);
			} catch (Exception e2) {
				e2.printStackTrace();
			}
			e.printStackTrace();
			log.error("execute Error: " + e.getMessage());
		}
		
	}

}
