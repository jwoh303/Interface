package com.koreab2b.common.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;
import com.koreab2b.common.CommonUtil;

@SuppressWarnings("unchecked")
public class UpdateIfStatus_DaoImpl implements UpdateIfStatus_Dao {
	private static 	Logger		log		= Logger.getLogger(UpdateIfStatus_DaoImpl.class);
	private SqlMapClient sqlMapper;

	public UpdateIfStatus_DaoImpl() {
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

	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public void updateIfStatus(Map<String, String> pMap) throws Exception{
		this.sqlMapper.update("updateIfStatus", pMap);
	}

	@Override
	public void insertMroJobDate(Map<String, String> pMap) {
		try {
			this.sqlMapper.update("insertMroJobDate", pMap);	
		} catch (Exception e) {
			log.error(CommonUtil.printStackTraceToString(e));
		}
	}
}