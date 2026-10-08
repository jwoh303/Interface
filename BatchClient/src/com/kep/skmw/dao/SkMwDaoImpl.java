/**
 * 
 */
package com.kep.skmw.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

/**
 * @author jiwon
 *
 */
public class SkMwDaoImpl implements SkMwDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public SkMwDaoImpl() {
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
			log.error("####### HkInnDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	@Override
	public List<Map<String, Object>> selectSkMwToken() throws Exception {
		return this.sqlMapper.queryForList("selectSkMwToken");
	}

	@Override
	public List<Map<String, Object>> selectSkMwItemList() throws Exception {
		return this.sqlMapper.queryForList("selectSkMwItemList");
	}
	
	@Override
	public void updateSkMwItem(Map<String, Object> item) throws Exception {
		this.sqlMapper.update("updateSkMwItem", item);
	}

	@Override
	public void updateSkMwErr() throws Exception {
		this.sqlMapper.update("updateSkMwErr");		
	}	

}
