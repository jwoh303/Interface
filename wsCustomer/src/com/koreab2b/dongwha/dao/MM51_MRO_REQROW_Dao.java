package com.koreab2b.dongwha.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;

public class MM51_MRO_REQROW_Dao {
	
	private Logger log = Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;
	
	public MM51_MRO_REQROW_Dao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
		    log.error(e.getMessage());
		    throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	public List<Map<String,String>> selectItemList() throws Exception {
		return sqlMapper.queryForList("selectItemList");
	}
	public void UpdateItemList( Map <String, String> pMap) throws Exception {
		sqlMapper.update("UpdateItemList",pMap);
	}
}
