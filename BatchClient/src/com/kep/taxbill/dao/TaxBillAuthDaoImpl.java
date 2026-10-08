package com.kep.taxbill.dao;

import java.io.Reader;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class TaxBillAuthDaoImpl implements TaxBillAuthDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public TaxBillAuthDaoImpl() {
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
	public List<Map<String, String>> selectTaxBillAuth() throws Exception {
		
		Map<String, String> pMap	= new HashMap<String, String>();
		pMap.put("OP_TYPE", CommonProperty.getDB_CONN());
		return this.sqlMapper.queryForList("selectTaxBillAuth", pMap);
	}

	@Override
	public void updateTaxBillAuth(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateTaxBillAuth", pMap);
	}

}
