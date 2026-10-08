package com.kep.jwph.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;


@SuppressWarnings("unchecked")
public class JwphDaoImpl implements JwphDao {

	private static Logger log	= Logger.getLogger( JwphDaoImpl.class.getName() );
	
private SqlMapClient sqlMapper;
	
	public JwphDaoImpl() {
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
	public List<Map<String, String>> selectPoStatusTargetList() throws Exception {
		return sqlMapper.queryForList("selectJwphPoStatusTargetList");
	}

	@Override
	public void updateJwphAppSubmitResult(Map<String, String> iMap) throws Exception {
		this.sqlMapper.update("updateJwphAppSubmitResult", iMap);
		
	}

	@Override
	public List<Map<String, String>> selectItemTargetList() throws Exception {
		return sqlMapper.queryForList("selectJwphItemTargetList");
	}

	@Override
	public void updateJwphItSubmitResult(Map<String, String> resultMap) throws Exception{
		this.sqlMapper.update("updateJwphItSubmitResult", resultMap);
		
	}
}
