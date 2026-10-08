package com.kep.taxbill.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

@SuppressWarnings("unchecked")
public class TaxAccountErpDaoImpl implements TaxAccountErpDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public TaxAccountErpDaoImpl() {
		try {
			String source	= "";
			source	= "conf/SqlMapConfig_Erp.xml";
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, String>> selectTargetList() throws Exception {
		return this.sqlMapper.queryForList("selectTargetList");
	}

	@Override
	public List<Map<String, Object>> selectTaccountIfGLList(
			Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectTaccountIfGLList", pMap);
	}

	@Override
	public List<Map<String, Object>> selectTaccountIfHisList(
			Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectTaccountIfHisList", pMap);
	}

}