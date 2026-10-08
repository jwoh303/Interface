package com.kep.gift.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class kepLinkDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	private String _CD_COMPANY = "TEST";
	
	public kepLinkDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
				this._CD_COMPANY = "1000";
			} else {
				source	= "conf/SqlMapConfig_Dev.xml";
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
	 * 링크디비조회 
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, String>> selectLinkList() throws Exception {
		return this.sqlMapper.queryForList("selectLinkList");
	}
	
	
	/**
	 * 판촉디비insert후 flag 변경 
	 * @return
	 * @throws Exception
	 */
	public void updateLinkFlag(Map<String, String> iMap) throws Exception {
		this.sqlMapper.update("updateLinkFlag", iMap);
	}

}
