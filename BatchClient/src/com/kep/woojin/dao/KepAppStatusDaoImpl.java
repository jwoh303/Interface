package com.kep.woojin.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class KepAppStatusDaoImpl implements KepAppStatusDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public KepAppStatusDaoImpl() {
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
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public SqlMapClient getSqlMapper() {
		return sqlMapper;
	}

	@Override
	public List<Map<String, String>> selectAppTargetList()
			throws Exception {
		return this.sqlMapper.queryForList("selectAppTargetList");
	}

	@Override
	public void updateAppTargetInfo(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateAppTargetInfo", pMap);
	}

	@Override
	public void updateAppStatus(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateAppStatus", pMap);		
	}

}
