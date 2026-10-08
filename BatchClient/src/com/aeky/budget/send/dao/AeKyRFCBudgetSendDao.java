package com.aeky.budget.send.dao;

import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;

import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class AeKyRFCBudgetSendDao {

private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private SqlMapClient sqlMapper;
	
	public AeKyRFCBudgetSendDao() {
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
	
	public List<Map<String, String>> getRfcAeKyProperties() throws Exception {

		List<Map<String, String>> ret = new ArrayList<Map<String,String>>();
		try {
			sqlMapper.startTransaction();
			
			Map<String, String> pMap = new HashMap<String, String>();
			pMap.put("server_mode", CommonProperty.getDB_CONN());
			
			ret = sqlMapper.queryForList("selectRfcAeKyProperties",pMap);
			
			sqlMapper.commitTransaction();
		} finally {
			sqlMapper.endTransaction();
		}
		
		
		return ret;
	}
	
	public List<Map<String, String>> ZMRO_BD_LIST_HD() throws Exception {

		List<Map<String, String>> ret = new ArrayList<Map<String,String>>();
		try {
			sqlMapper.startTransaction();
			
			ret = sqlMapper.queryForList("ZMRO_BD_LIST_HD");
			
			sqlMapper.commitTransaction();
		} finally {
			sqlMapper.endTransaction();
		}
		
		
		return ret;
	}
	
	public List<Map<String, String>> ZMRO_BD_LIST_DT() throws Exception {

		List<Map<String, String>> ret = new ArrayList<Map<String,String>>();
		try {
			sqlMapper.startTransaction();
			
			ret = sqlMapper.queryForList("ZMRO_BD_LIST_DT");
			
			sqlMapper.commitTransaction();
		} finally {
			sqlMapper.endTransaction();
		}
		
		
		return ret;
	}
}
