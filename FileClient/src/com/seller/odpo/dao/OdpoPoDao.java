package com.seller.odpo.dao;

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

@SuppressWarnings("unchecked")
public class OdpoPoDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public OdpoPoDao() {
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
	
	public List<Map<String, String>> selectOdpoPoEventList() throws SQLException {
		return this.sqlMapper.queryForList("selectOdpoPoEventList");
	}
	
	public List<Map<String, String>> setectOdpoPoDetail(Map<String, String> pMap) throws SQLException {
		
		Map<String,String> tMap = (Map<String,String>)this.sqlMapper.queryForObject("setectOdpoCOMINFO", pMap);
		
		tMap.put("BUYER", pMap.get("BUYER"));
		tMap.put("PO_NO", pMap.get("PO_NO"));
	
		List<Map<String, String>> iMap = this.sqlMapper.queryForList("setectOdpoCOMINFO2", tMap);
		
		if (iMap.size() == 1) {
			return this.sqlMapper.queryForList("setectOdpoPoDetail_2", pMap);
		} else {
			return this.sqlMapper.queryForList("setectOdpoPoDetail_1", pMap);
		}
		
	}
	
	public void updateOdpoPohdSendInfo(Map<String, String> pMap) throws SQLException {
		this.sqlMapper.update("updateOdpoPohdSendInfo", pMap);
	}
	
	public int selectOdpoPorsCntChk(Map<String, String> pMap) throws SQLException {
		return (Integer)this.sqlMapper.queryForObject("selectOdpoPorsCntChk", pMap);
	}
	
	public void executeOdpoPoComplte(Map<String, String> pMap) throws SQLException {
		this.sqlMapper.insert("insertOdpoPors", pMap);
		this.sqlMapper.update("updateOdpoPodtComplete", pMap);
		this.sqlMapper.update("updateOdpoPohdComplete", pMap);
		this.sqlMapper.delete("deleteOdpoPoEvent",pMap);
	}
}