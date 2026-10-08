package com.kep.supplyon.dao;

import java.io.Reader;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class ParseEDIDaoImpl implements ParseEDIDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	private SqlMapClient sqlMapper;
	
	public ParseEDIDaoImpl() {
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
	public void insertPurchaseOrder(Map<String, String> pMap) throws Exception{
		this.sqlMapper.insert("insertPurchaseOrder", pMap);
	}
	@Override
	public void informErrorOccurs(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("informErrorOccurs", pMap);
		
	}

}
