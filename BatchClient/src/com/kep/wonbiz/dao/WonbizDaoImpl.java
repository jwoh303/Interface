package com.kep.wonbiz.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class WonbizDaoImpl implements WonbizDao {

	private static Logger log	= Logger.getLogger(WonbizDaoImpl.class.getName() );
	
	private SqlMapClient sqlMapper;
		
		public WonbizDaoImpl() {
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
	public List<Map<String,Object>> selectWonbizTargetList() throws Exception {
		return sqlMapper.queryForList("selectWonbizTargetList");
	}

	@Override
	public void updateSubmitResult(Map<String, Object> iMap) throws Exception {
		this.sqlMapper.update("updateSubmitResult", iMap);
	}

}
