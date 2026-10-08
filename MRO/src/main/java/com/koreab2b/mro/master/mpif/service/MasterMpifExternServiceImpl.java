package com.koreab2b.mro.master.mpif.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.net.ssl.HttpsURLConnection;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpif.dao.MasterMpifExternDao;

@Service("masterMpifExternService")
public class MasterMpifExternServiceImpl implements MasterMpifExternService {

	@Autowired
	private MasterMpifExternDao masterMpifExternDao;

	private Connection conn	= null;

	@Override
	public String getCAULoginCheck(Map<String, String> pMap) {
		
		List<Map<String, String>> dbs = masterMpifExternDao.selectBuyerIfDbInfo(pMap);
		String _rtn = "";
		Map<String, String> dbInfo = new HashMap<String, String>();

		StringBuffer sql		= new StringBuffer();
		PreparedStatement stmt	= null;
		ResultSet rs			= null;
		
		String st_server_mode = pMap.get("st_server_mode");

		dbInfo.put("CLASS_NAME", dbs.get(0).get("CLASS_NAME"));
		if ("2".equals(st_server_mode)) {
			// LIVE
			dbInfo.put("CONN_STR", dbs.get(0).get("LIVE_CONN_STR"));
			dbInfo.put("ID", dbs.get(0).get("LIVE_ID"));
			dbInfo.put("PW", dbs.get(0).get("LIVE_PW"));
		} else {
			// DEV
			dbInfo.put("CONN_STR", dbs.get(0).get("DEV_CONN_STR"));
			dbInfo.put("ID", dbs.get(0).get("DEV_ID"));
			dbInfo.put("PW", dbs.get(0).get("DEV_PW"));
		}
		
		this.getDBConnection(dbInfo);
		
		try {
			sql.append("SELECT GENAFFAIR.F_GET_DECRYPT(?) AS LEGACY_USER_ID FROM DUAL ");
			stmt = this.conn.prepareStatement(sql.toString());
			stmt.setString(1, pMap.get("st_user_id"));
			
			rs = stmt.executeQuery();
			
			while (rs.next()) {
				_rtn = rs.getString("LEGACY_USER_ID");
			}
			
		} catch (Exception e) {
			_rtn = "FAIL";
		} finally {
			try {if(rs != null) {rs.close();} } catch (Exception e2) {}
			try {if(stmt != null) {stmt.close();} } catch (Exception e2) {}
			try {if(this.conn != null) {this.conn.close();} } catch (Exception e2) {}
		}
		
		return _rtn;
	}

	private void getDBConnection(Map<String, String> pMap) {

    	try {
    		if (this.conn == null || this.conn.isClosed() ) {
        		Class.forName( pMap.get("CLASS_NAME") );
        		String conStr	= pMap.get("CONN_STR");	//prop.getProperty("db.conStr");
        		String id		= pMap.get("ID");	//prop.getProperty("db.id");
        		String pw		= pMap.get("PW");	//prop.getProperty("db.pw");
        		this.conn		= DriverManager.getConnection(conStr, id, pw);
			}
		} catch (Exception e) {
			e.printStackTrace();
			try {if(this.conn != null) {this.conn.close();} } catch (Exception e2) {}
		}
	}

	@Override
	public Map<String, String> getHansLoginCheck(Map<String, String> pMap) {
		
		Map<String, String> resultMap = new HashMap<String, String>();
		String urlPath = pMap.get("buyerUrl");
		String postUrl = urlPath + "?token=" + pMap.get("buyer_token");
		JSONObject json = new JSONObject();
		String response = null;
		
		try {
			URL url = new URL(postUrl);
			String auth  = "Basic 7afsxNGGEeCKu50dssgu72auznqhBzxl";
			HttpsURLConnection con = (HttpsURLConnection) url.openConnection();
			
			con.setRequestMethod("POST");
			con.setRequestProperty("Accept", "application/json");
			con.setRequestProperty("Content-Type", "application/json");
			con.setRequestProperty("Authorization", auth);
			con.setDoOutput(true);
			
			BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			
			StringBuffer sb = new StringBuffer();
			String inputline;
			
			while((inputline = br.readLine()) != null) {
				sb.append(inputline);
			}
			br.close();

			JSONParser jsonParser = new JSONParser();
			JSONObject jsonResponse = (JSONObject)jsonParser.parse(sb.toString());
			JSONObject resultObj1 = (JSONObject) jsonResponse ;
			JSONObject resultObj2 = (JSONObject) resultObj1.get("obj");
			
			//결과값 수신
    		int rc = con.getResponseCode();
    		System.out.println("rc --------------------- " + rc);
    		
    		if(rc==200 && "200".equals((String)resultObj1.get("code"))){
    			resultMap.put("FLAG", "S");
        		resultMap.put("empNo", (String)resultObj2.get("id"));
			}else {
				resultMap.put("FLAG", "FAIL");
			}
		} catch (Exception e) {
			System.out.println("한샘 로그인 Exception" + e);
			resultMap.put("FLAG", "FAIL");
		}
		return resultMap;
	}

}