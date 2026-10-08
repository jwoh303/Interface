package com.buyer.gsep.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class GsepPoDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public GsepPoDao() {
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
	
	public void insertPodtUC(Map<String,String> iMap) throws SQLException {
		this.sqlMapper.insert("insertGsepPodtUC", iMap);
	}
	public void updateIfPodt(Map<String,String> iMap) throws SQLException {
		this.sqlMapper.update("updateGsepPodt", iMap);
	}
	public Map<String, String> Gsep_PoIs(Map<String,String> iMap) throws SQLException{
		return (Map<String, String>)this.sqlMapper.queryForObject("Gsep_PoIs", iMap);  
	}
	public Map<String, String> Gsep_UserIs(Map<String,String> iMap) throws SQLException{
		return (Map<String, String>)this.sqlMapper.queryForObject("Gsep_UserIs", iMap);  
	}
}
