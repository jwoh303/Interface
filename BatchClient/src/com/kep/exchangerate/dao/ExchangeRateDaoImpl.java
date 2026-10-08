package com.kep.exchangerate.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class ExchangeRateDaoImpl implements ExchangeRateDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public ExchangeRateDaoImpl() {
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
	public void saveExchangeRateInfo(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("mergeExchangeRateInfo", pMap);
	}

	@Override
	public void saveExchangeRateInfo2(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("mergeExchangeRateInfo2", pMap);
	}
	
	@Override
	public List<Map<String, String>> getCurrencyCodeList() throws Exception {
		return this.sqlMapper.queryForList("selectCURCodeList");
	}

	@Override
	public List<Map<String, Object>> getCurrencyInfoList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectCURInfoList",pMap);
	}

	@Override
	public void saveExchangeRateHD(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("updateExchangeRateHD", pMap);
	}

	@Override
	public void sendExchangeAlertMail(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("sendMail", pMap);
	}

	@Override
	public List<Map<String, String>> getSendMailUser(Map<String, Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectSendMailUser", pMap);
	}
}
