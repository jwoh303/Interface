package com.kep.kumh.pr.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class GrLoadDaoImpl implements GrLoadDao {
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public GrLoadDaoImpl() {
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
			log.error("PrSubmitDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<Map<String, String>> selectPlantList() throws Exception {
		return sqlMapper.queryForList("selectKumhPlantList");
	}

	@Override
	public void insertKumhGr(Map<String, String> arrMap) throws Exception {
		this.sqlMapper.insert("insertKumhGr", arrMap);
	}

}
