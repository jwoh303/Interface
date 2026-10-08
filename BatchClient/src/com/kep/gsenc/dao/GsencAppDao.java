package com.kep.gsenc.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class GsencAppDao {
	
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	private SqlMapClient sqlMapper;

	public GsencAppDao() {
		try {
			String source	= "";
			if ( "2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_KEPCON_Live.xml";
			} else {
				source	= "conf/SqlMapConfig_KEPCON_Dev.xml";
			}
			Reader reader = Resources.getResourceAsReader(source);
			this.sqlMapper = SqlMapClientBuilder.buildSqlMapClient(reader);
		} catch (Exception e) {
			e.printStackTrace();
			log.error(this.getClass().getName() + " Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	public List<Map<String, String>> selectGsencAppHeaderList() throws Exception {
		return sqlMapper.queryForList("selectGsencAppHeaderList");
	}
	
	public List<Map<String, String>> selectGsencAppPathList(Map<String, String> iMap) throws Exception {
		return sqlMapper.queryForList("selectGsencAppPathList", iMap);
	}

	public void updateGsencAppResult(Map<String, String> iMap)  throws Exception {
		sqlMapper.update("updateGsencAppResult", iMap);
	}
	
	public List<Map<String, Object>> selectGsencAppContentsList(Map<String, String> iMap) throws Exception {
		return sqlMapper.queryForList("selectGsencAppContentsList", iMap);
	}
	
	public List<Map<String, Object>> selectGsencAppAttachList(Map<String, String> iMap) throws Exception {
		return sqlMapper.queryForList("selectGsencAppAttachList", iMap);
	}
}
