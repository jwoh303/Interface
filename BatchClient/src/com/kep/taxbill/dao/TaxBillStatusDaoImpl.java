package com.kep.taxbill.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class TaxBillStatusDaoImpl implements TaxBillStatusDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public TaxBillStatusDaoImpl() {
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

	@Override
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public List<Map<String, String>> selectSearchCondition(Map<String, String> pMap) throws Exception {
		return sqlMapper.queryForList("selectSearchCondition", pMap);
	}

	@Override
	public int updateTaxBillStatus(Map<String, String> pMap) throws Exception {
		return sqlMapper.update("updateTaxBillStatus", pMap);
	}

	@Override
	public List<Map<String, String>> selectRunCheck(Map<String, String> pMap) throws Exception {
		return sqlMapper.queryForList("runCheck", pMap);
	}
}
