package com.kep.hanwha.org.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

public class HanwhaOrgDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public HanwhaOrgDao() {
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
			log.error("HanwhaOrgDao Error : " + CommonUtil.printStackTraceToString(e));
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public void deleteHanwhaOrgDept(Map<String, String> pMap) throws SQLException {
		this.sqlMapper.insert("deleteHanwhaOrgDept",pMap);
	}
	
	public void insertHanwhaOrgDeptInfo(Map<String, String> pMap) throws SQLException {
		this.sqlMapper.insert("insertHanwhaOrgDeptInfo",pMap);
	}
}
