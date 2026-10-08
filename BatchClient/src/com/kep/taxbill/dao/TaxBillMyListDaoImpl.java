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
public class TaxBillMyListDaoImpl implements TaxBillMyListDao {

	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public TaxBillMyListDaoImpl() {
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
	public List<Map<String, String>> selectSearchMyListCondition() throws Exception {
		return sqlMapper.queryForList("selectSearchMyListCondition");
	}

	@Override
	public void insertTaxBillMyListInfo(Map<String, Object> pMap) throws Exception {
		sqlMapper.insert("insertTaxBillMyListInfo", pMap);
	}

	@Override
	public void updateTaxBillMyListInfo(Map<String, Object> pMap) throws Exception {
		sqlMapper.update("updateTaxBillMyListInfo", pMap);
	}

	@Override
	public List<Map<String, String>> checkMyListInfo(Map<String, Object> pMap) throws Exception {
		return sqlMapper.queryForList("selectMyListInfoCheckResult", pMap);
	}

	@Override
	public List<Map<String, String>> selectDtiStatusInfoCount(Map<String, Object> pMap) throws Exception {
		return sqlMapper.queryForList("selectDtiStatusCount", pMap);
	}

	@Override
	public void insertTaxBillDtiStatusInfo(Map<String, Object> pMap) throws Exception {
		sqlMapper.insert("insertDtiStatusInfo", pMap);
	}
}
