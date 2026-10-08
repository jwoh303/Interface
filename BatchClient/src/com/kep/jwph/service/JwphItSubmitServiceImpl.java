package com.kep.jwph.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.log4j.Logger;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kep.common.CommonProperty;
import com.kep.jwph.dao.JwphDao;
import com.kep.jwph.dao.JwphDaoImpl;

public class JwphItSubmitServiceImpl implements JwphItSubmitService {
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	@Override
	public void execute() throws Exception {
		JwphDao dao = new JwphDaoImpl();
		String ApiURL =  CommonProperty.getJWPH_URL() + "/product";
		
		List<Map<String, String>> map = dao.selectItemTargetList();
		
		if (map != null && map.size() > 0) {
			URL url = null;
			url = new URL(ApiURL);
			for (int i = 0; i < map.size(); i++) {
				Map<String, String> resultMap = map.get(i);	
				HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
				
				String resultFlag = "E";
				
				try {
					JSONObject target	= new JSONObject();
					
					if("C".equals(resultMap.get("STATUS"))) {
						target.put("status", 	resultMap.get("STATUS"));
						target.put("mngCode",   resultMap.get("BUYER_ITEM_NO"));
						target.put("isChemical",resultMap.get("ISCHEMICAL"));
						target.put("id",resultMap.get("QUOTATION_NO"));
						if(resultMap.get("DATA01") != null) {
							target.put("file",resultMap.get("DATA01"));
						}
						JSONObject product	= new JSONObject();
						product.put("name", 	resultMap.get("DESCRIPTION"));
						product.put("price",resultMap.get("UNIT_PRICE"));
						product.put("spec",resultMap.get("SPECIFICATION"));
						if(resultMap.get("DATA02") != null) {
							product.put("imageUrl",resultMap.get("DATA02"));
						}
						JSONObject brand	= new JSONObject();
						brand.put("name",resultMap.get("ITEM_MAKER"));
						
						product.put("brand", brand);
						target.put("product", product);
					}else if("U".equals(resultMap.get("STATUS"))) {
						target.put("status", 	resultMap.get("STATUS"));
						target.put("mngCode",   resultMap.get("BUYER_ITEM_NO"));
						target.put("isChemical",resultMap.get("ISCHEMICAL"));
						
						if(resultMap.get("DATA01") != null) {
							target.put("file",resultMap.get("DATA01"));
						}
						
						JSONObject product	= new JSONObject();
						product.put("price",resultMap.get("UNIT_PRICE"));
						
						if(resultMap.get("DATA02") != null) {
							product.put("imageUrl",resultMap.get("DATA02"));
						}
						
						target.put("product", product);
					}else if("D".equals(resultMap.get("STATUS"))) {
						target.put("status", 	resultMap.get("STATUS"));
						target.put("mngCode",   resultMap.get("BUYER_ITEM_NO"));
					}
					
					log.info("targetList |||:" + target);
					
					con.setRequestMethod("POST");
					con.setRequestProperty("Content-Type", "application/json");
					con.setDoOutput(true);
					con.setDoInput(true);
					con.setConnectTimeout(10000);
					con.setReadTimeout(30000);
					
					OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream(), "UTF-8");
					wr.write(target.toString());
					wr.flush();
					wr.close();
					
					int responseCode = con.getResponseCode();

                    if (responseCode == HttpURLConnection.HTTP_OK) {
                        resultFlag = "Y";
                        log.info("API 호출 성공 (200)");
                    } else {
                        resultFlag = "E";
                        log.error("API 호출 실패, responseCode: " + responseCode);
                    }

				}catch (Exception e) {
					e.printStackTrace();
					log.error("JwphItSubmitServiceImpl execute Error : " + e.getMessage());
					resultFlag = "E";
				}finally {
					con.disconnect();
					resultMap.put("FLAG", resultFlag);
					dao.updateJwphItSubmitResult(resultMap);
				}
			}
		}
	}

}
