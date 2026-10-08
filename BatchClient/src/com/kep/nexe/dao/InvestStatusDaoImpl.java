package com.kep.nexe.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class InvestStatusDaoImpl implements InvestStatusDao {
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	
	public InvestStatusDaoImpl() {
		try {
			String source	= "";
			if ("5".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_CZC_Live.xml";
			} else if ("2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else if ("7".equals(CommonProperty.getDB_CONN()) || "8".equals(CommonProperty.getDB_CONN())) {
				source	= "conf/SqlMapConfig_CN_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error("InvestStatusDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}


	@Override
	public void insertNexeInvestBudget(Map<String, Object> iMap) throws Exception {
		this.sqlMapper.insert("insertNexeInvestBudget", iMap);
	}


	@Override
	public void insertNexeInvestAsset(Map<String, Object> jMap) throws Exception {
		this.sqlMapper.insert("insertNexeInvestAsset", jMap);
	}
}
