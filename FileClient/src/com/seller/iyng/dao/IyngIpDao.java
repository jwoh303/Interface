package com.seller.iyng.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class IyngIpDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public IyngIpDao() {
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
	
	public void updateDBDispatcher() throws SQLException {
		this.sqlMapper.update("updateDBDispatcher");
		this.sqlMapper.update("updateDBDispatcher2");
	}
	public List<Map<String, String>> selectIyngLogisCur() throws SQLException {
		return this.sqlMapper.queryForList("selectIyngLogisCur");
	}
	public List<Map<String,String>> DATA_Assign(Map<String,String> pMap) throws SQLException{
		return this.sqlMapper.queryForList("DATA_Assign",pMap);
	}
	public void DATA_Update(Map<String,String> pMap) throws SQLException {
		this.sqlMapper.update("DATA_Update", pMap);
	}
}
