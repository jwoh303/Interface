package com.koreab2b.po.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.koreab2b.common.CommonProperty;

@SuppressWarnings("unchecked")
public class GRP_MM1200_DaoImpl implements GRP_MM1200_Dao {

	
	private Logger log	= Logger.getLogger(this.getClass());
	private SqlMapClient sqlMapper;

	public GRP_MM1200_DaoImpl() {
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
	public List<Map<String, String>> selectDeliveryList() throws Exception {
		return this.sqlMapper.queryForList("selectDeliveryList");
	}

	@Override
	public int updateReadyData() throws Exception {
		return this.sqlMapper.update("updateReadyData");
	}

	@Override
	public int updateSendData(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.update("updateSendData", pMap);
	}
}
