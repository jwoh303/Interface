package com.kep.gift.dao;

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
public class KepGiftDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	public String _CD_COMPANY = "TEST";
	
	
	public KepGiftDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_PRMT_Live.xml";
				this._CD_COMPANY = "1000";
			} else {
				source	= "conf/SqlMapConfig_PRMT_Dev.xml";
				this._CD_COMPANY = "TEST";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	
	/**
	 * 판촉디비에 select 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectLinkData(Map<String, String> iMap)throws Exception {
		return this.sqlMapper.queryForList("selectLinkData", iMap);
	}
	
	
	/**
	 * 판촉디비에 insert 
	 * @return
	 * @throws Exception
	 */
	public void insertLinkData(Map<String, String> iMap) throws Exception{
		this.sqlMapper.insert("insertLinkData", iMap);
	}


	/**
	 * 판촉디비에 update 
	 * @return
	 * @throws Exception
	 */
	public void updateLinkData(Map<String, String> iMap) throws Exception{
		this.sqlMapper.update("updateLinkData", iMap);
	}

	
}
