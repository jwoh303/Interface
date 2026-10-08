package com.buyer.daed.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class DaedPrDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public DaedPrDao() {
		try {	
			String source	= "";
			
			String dbConn = "";	// 2:운영, 0:개발
			String dbType = CommonProperty.getDB_TYPE();	// KEPMP, KEPCON

			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				dbConn = "Live";
			} else {
				dbConn = "Dev";
			}
			
			source = "conf/SqlMapConfig_"+dbType+"_"+dbConn+".xml";
			
			log.debug("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public List<Map<String, String>> selectDBDispatcher() throws SQLException {
		return this.sqlMapper.queryForList("DAED_selectDBDispatcher");
	}
	public List<Map<String, String>> PRDT_SELECT(Map<String, String> pMap) throws SQLException {
		return this.sqlMapper.queryForList("DAED_PRDT_SELECT",pMap);
	}
	public void TRXL_Dequeue(Map<String,String> pMap) throws SQLException {
		this.sqlMapper.update("DAED_TRXL_Dequeue", pMap);
	}
	public void LogWrite(Map<String,String> pMap) throws SQLException {
		this.sqlMapper.update("mergeIfProgress", pMap);
	}
	public void REIF_LOAD(Map<String,String> pMap) throws SQLException {
		
		String type = pMap.get("TYPE");
		String [] arr = pMap.get("KEP_PR").split("-");
		Map <String,String> tMap = new HashMap<String,String>();
		tMap.put("BUYER" , "KRDAED0079");
		tMap.put("PR_NO", arr[0]);
		tMap.put("PR_SEQ", arr[1]);
		
		if("D".equals(type)) {
			this.sqlMapper.update("DaedPRDT_D", tMap);
		} else if("F".equals(type)) {
			this.sqlMapper.update("DaedPRDT_F", tMap);
		}
	
	}
}
