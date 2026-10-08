package com.koreab2b.lottecs.dao;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.apache.ibatis.io.Resources;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;



@Repository("lottecsDao")
@Transactional
public class LottecsDaoImpl implements LottecsDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(LottecsDaoImpl.class);
	private SqlMapClient sqlMapper;	
	private String _rtnMsg = "";

	
	public LottecsDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			LOGGER.error("####### LottecsDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
		
	}


	public Map<String, Object> processLotteMpRqAppSend(Map<String, Object> pMap) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();

		String Data = "";
		String moinKey = "6f865296000LCLIQ|d674d50aeffe48c68b3018f3d233d2f1"; //운영키값
		String appUrl ="https://eaiext.lottechilsung.co.kr/ext";
		
		URL url = null;
		url = new URL(appUrl);
		HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
		/*	롯데칠성 암복호화 사용법
			String strEnc = MOIN.Security.Cryptography.Symmetric.SymmetricEncryptUrl(Data, moinKey); //암호화
			String result = MOIN.Security.Cryptography.Symmetric.SymmetricDecryptUrl(Data, moinKey); //복호화 		*/
		
		try {
			//견적단가합의 or 입고등록 link 테이블에 insert
			String mode = (String) pMap.get("moduleId");
			String key_no = (String)pMap.get("keyvalue");
			Map<String, String> modeMap = new HashMap<String, String>();
			String grDate = (String)pMap.get("grDate");
		  
				  
			if(mode.equals("WAREHOUSING")) { //입고 
				modeMap.put("key_no", key_no); 
				modeMap.put("ori_gr_date", grDate.replaceAll(" ", "")); 
				this.sqlMapper.update("updateBuyerWmGrWarehousingGrAppSendDBlinkList", modeMap); 
				LOGGER.info("pMap :::::::: WAREHOUSING" + modeMap);
			}else if(mode.equals("ORDER")){ //견적단가 
				modeMap.put("key_no", key_no);
				this.sqlMapper.update("updateRqdtAppSendDBlinkList", modeMap);
				LOGGER.info("pMap :::::::: ORDER" + modeMap);
			}
			
			//DATA
			JSONObject header	= new JSONObject();
			JSONObject data	= new JSONObject();
			JSONObject body	= new JSONObject();
			
			//HEADER
			Locale Locale = new Locale("KOREAN" , "KOREA");
			Date today = new Date();
			String pattern = "yyyyMMddHHmmssSSS";
			SimpleDateFormat formatter = new SimpleDateFormat(pattern, Locale);
			String currentdate = formatter.format(today);
			
			String auth = MOIN.Security.Cryptography.Symmetric.SymmetricEncryptUrl("|" + (String) pMap.get("id") + "|", moinKey); //암호화
			String xml = MOIN.Security.Cryptography.Symmetric.SymmetricEncryptUrl((String) pMap.get("xmlData"), moinKey); //암호화
			
			header.put("glob_id",  "KEPDWP" + currentdate + "0000001");
			header.put("snd_svc_id", "KEP");
			header.put("rcv_svc_id", "DWP");
			header.put("eai_if_id", "IFO_EXT_DWP_0001");
			header.put("req_res_cd", "S");
			header.put("env_cd", "");
			header.put("ext_sys_cd", "");
			header.put("ext_guid", "");
			header.put("ext_proc_cd", "");
			header.put("rstn_yn", "0");
			header.put("err_cd", "");
			header.put("err_msg", "");
			
			data.put("companyCode", "011750");
			data.put("systemId", "PRD");
			data.put("approvalType", "1");
			data.put("authinfo", auth);
			data.put("xmlData", xml);
			
			body.put("HEADER", header); 
			body.put("DATA", data); 
			
			LOGGER.info("modeMap :::::::: " + modeMap);
			LOGGER.info("body :::::::: " + body);
			
			con.setRequestMethod("POST");
			con.setRequestProperty("Content-Type", "application/json");
			con.setDoOutput(true);
			con.setDoInput(true);
			con.setConnectTimeout(1000 * 60);
			con.setReadTimeout(5000);
			con.setUseCaches(false);
			
			OutputStreamWriter wr = new OutputStreamWriter(con.getOutputStream());
			wr.write(body.toString());
			wr.flush();
			wr.close();
			
			StringBuilder sb = new StringBuilder();
			if (con.getResponseCode() == HttpURLConnection.HTTP_OK) {
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
				LOGGER.info("jsonResponse ok:::::::: " + jsonResponse);
				con.disconnect();
				
				JSONObject ResData = (JSONObject) jsonResponse.get("DATA");
				LOGGER.info("ResData ok:::::::: " + ResData);
				
				
				String resultFlag= (String) ResData.get("code");
				LOGGER.info("resultFlag ok:::::::: " + resultFlag);
				
				if("OK".equals(resultFlag)) {
					String resultUrl =  MOIN.Security.Cryptography.Symmetric.SymmetricDecryptUrl((String)ResData.get("data"), moinKey);
				
					returnMap.put("resultUrl", resultUrl);
					returnMap.put("resultCode", "OK"); 
					LOGGER.info("resultUrl ok:::::::: " + resultUrl);
				} else {
					String resultMsg =  MOIN.Security.Cryptography.Symmetric.SymmetricDecryptUrl((String)ResData.get("msg"), moinKey);
					returnMap.put("msg", resultMsg);
					returnMap.put("resultCode", "FAIL");
				}
			} else {
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line).append("\n");
				}
				br.close();
				JSONParser jsonParser = new JSONParser();
				JSONObject jsonResponse = (JSONObject) jsonParser.parse(sb.toString());
				con.disconnect();
				LOGGER.info("jsonResponse fail:::::::: " + jsonResponse);
				returnMap.put("resultCode", "FAIL"); 
				returnMap.put("msg", "I/F ERR");
			}
		  
		} catch (Exception e) {
			returnMap.put("resultCode", "FAIL"); 
			returnMap.put("msg", "I/F ERR");
			e.printStackTrace();
			LOGGER.error("processLotteMpRqAppSend Error : " + e.getMessage());
		}
		
		return returnMap;
	}
}
