/**
 * 
 */
package com.kep.aeky.dao;

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
public class AekyDaoImpl implements AekyDao {
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public AekyDaoImpl() {
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
			log.error("####### AekyDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, Object>> selectAekyArSendHd() throws Exception {
		return this.sqlMapper.queryForList("selectAekyArSendHd");
	}

	@Override
	public List<Map<String, Object>> selectAekyArSend(Map<String,Object> iMap) throws Exception {
		return this.sqlMapper.queryForList("selectAekyArSend", iMap);
	}
	
	@Override
	public List<Map<String, String>> selectParamKey() throws Exception {
		return this.sqlMapper.queryForList("selectParamKey");
	}
	
	@Override
	public List<Map<String, String>> selectParamMroKey() throws Exception {
		return this.sqlMapper.queryForList("selectParamMroKey");
	}

	@Override
	public void updateAekyArSend(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("updateAekyArSend", pMap);	
		 
	}

	@Override
	public void insertAekyBdgt(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.insert("insertAekyBdgt", pMap);	
	}

}
