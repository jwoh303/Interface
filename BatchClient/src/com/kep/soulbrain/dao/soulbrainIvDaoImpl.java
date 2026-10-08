package com.kep.soulbrain.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class soulbrainIvDaoImpl implements soulbrainIvDao {
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public soulbrainIvDaoImpl() {
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
			log.error("PrSubmitDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	

	@Override
	public void updateIvResult(Map<String, String> pMap) throws Exception {
		sqlMapper.update("updateIvResult", pMap);
		
	}

	@Override
	public List<Map<String, String>> selectTargetHdList() throws Exception {
		return sqlMapper.queryForList("selectTargetHdList");
	}


	@Override
	public List<Map<String, String>> selectTargetDtList(Map<String, String> map) throws Exception {
		return sqlMapper.queryForList("selectTargetDtList", map);
	}


	@Override
	public void saveIvResult(Map<String, String> resultMap) throws Exception {
		sqlMapper.insert("saveIvResult", resultMap);
		
	}

}
