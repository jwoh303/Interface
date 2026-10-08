package com.kep.nexe.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class PrSubmitDaoImpl implements PrSubmitDao {
	
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	
	public PrSubmitDaoImpl() {
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
			log.error("PrSubmitDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}


	@Override
	public List<Map<String, String>> selectPrTargetList() throws Exception {
		return sqlMapper.queryForList("selectNexePrTargetList");
	}


	@Override
	public List<Map<String, String>> selectPrList(Map<String, String> map) throws Exception {
		return sqlMapper.queryForList("selectNexePrList", map);
	}


	@Override
	public void updateNexePrSendResult(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.update("updateNexePrSendResult", resultMap);
	}


	@Override
	public List<Map<String, String>> selectOfcPrTargetList() throws Exception {
		return sqlMapper.queryForList("selectNexeOfcPrTargetList");
	}


	@Override
	public void updateNexeOfcPrSendResult(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.update("updateNexeOfcPrSendResult", resultMap);
	}
}
