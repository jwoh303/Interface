package com.buyer.daed.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

public class DeadGrDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public DeadGrDao() {
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
			// EX) conf/SqlMapConfig_KEPMP_Live.xml, conf/SqlMapConfig_KEPCON_Dev.xml
			
			log.debug("Source Info : " + source);
			
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public Map<String, String> Daed_getBuyerItemNo(Map<String, String> pMap) throws SQLException {
		return (Map<String, String>)this.sqlMapper.queryForObject("Daed_getBuyerItemNo", pMap);
	}
	
	public void insertGrdtDAED(Map<String, String> pMap) throws SQLException  {
		this.sqlMapper.insert("insertGrdtDAED", pMap);
	}
}
