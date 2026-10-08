package com.kep.obBeer.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class ObBeerPoDaoImpl implements ObBeerPoDao {
	
	private static Logger log	= Logger.getLogger( ObBeerPoDaoImpl.class.getName() );

	private SqlMapClient sqlMapper;
	
	public ObBeerPoDaoImpl() {
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
	public void insertObBeerPo(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.insert("insertObBeerPo", resultMap);
	}

	@Override
	public List<Map<String, String>> selectPoStatusTargetList() throws Exception {
		return sqlMapper.queryForList("selectPoStatusTargetList");
	}

	@Override
	public void updateObAppSubmitResult(Map<String, String> iMap) throws Exception {
		this.sqlMapper.update("updateObAppSubmitResult", iMap);
		
	}

	@Override
	public List<Map<String, String>> selectIvSendTargetList() throws Exception {
		return sqlMapper.queryForList("selectObIvSendTargetList");
	}

	@Override
	public void updateObIvSendResult(Map<String, String> iMap) throws Exception {
		this.sqlMapper.update("updateObIvSendResult", iMap);
		
	}


}
