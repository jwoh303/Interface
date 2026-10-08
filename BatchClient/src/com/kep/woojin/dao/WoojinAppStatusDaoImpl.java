package com.kep.woojin.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class WoojinAppStatusDaoImpl implements WoojinAppStatusDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public WoojinAppStatusDaoImpl() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_MSSQL_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_MSSQL_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public SqlMapClient getSqlMapper() {
		return sqlMapper;
	}

	@Override
	public Map<String, String> selectBuyerAppInfo(Map<String, String> pMap) throws Exception {
		return (Map<String, String>)this.sqlMapper.queryForObject("selectBuyerAppInfo", pMap);
	}

}
