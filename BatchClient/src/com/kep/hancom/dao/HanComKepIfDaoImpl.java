package com.kep.hancom.dao;

import java.io.Reader;
import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class HanComKepIfDaoImpl implements HanComKepIfDao{
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HanComKepIfDaoImpl() {
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
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public int insertIfCode(Map<String, Object> paramMap) {
		int result = 1;
		try {
			this.sqlMapper.update("insertIfCode", paramMap);	
		} catch (Exception e) {
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
		}
		return result;
	}

	@Override
	public void execProcIf() {
		try {
			this.sqlMapper.update("execProcIf");
		} catch (Exception e) {
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
		}
		
	}
}
