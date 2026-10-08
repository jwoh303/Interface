package com.koreab2b.phil.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.ibatis.io.Resources;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;

@Repository("philDao")
public class PhilDaoImpl implements PhilDao {
	private static final Logger LOGGER = LoggerFactory.getLogger(PhilDaoImpl.class);	
	private SqlMapClient sqlMapper;	
	
	public PhilDaoImpl() {
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
			LOGGER.error("####### PhilDaoImpl Error : "+ e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	public void insertIfLog(Map<String, Object> logMap) throws Exception {
		this.sqlMapper.insert("insertIfLog", logMap);
	}

}
