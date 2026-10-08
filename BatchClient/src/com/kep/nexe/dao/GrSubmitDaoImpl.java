package com.kep.nexe.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class GrSubmitDaoImpl implements GrSubmitDao {

	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );
	
	
	public GrSubmitDaoImpl() {
		try {
			String source	= "";
			if ("5".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_CZC_Live.xml";
			} else if ("2".equals(CommonProperty.getDB_CONN()) ) {
				source	= "conf/SqlMapConfig_Live.xml";
			} else if ("7".equals(CommonProperty.getDB_CONN()) || "8".equals(CommonProperty.getDB_CONN())) {
				source	= "conf/SqlMapConfig_CN_Live.xml";
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
	public List<Map<String, String>> selectGrTargetList() throws Exception {
		return sqlMapper.queryForList("selectNexeGrTargetList");
	}

	@Override
	public List<Map<String, String>> selectGrList(Map<String, String> map) throws Exception {
		return sqlMapper.queryForList("selectNexeGrList", map);
	}

	@Override
	public void updateNexeGrResult(Map<String, String> resultMap) throws Exception {
		this.sqlMapper.update("updateNexeGrResult", resultMap);
	}

}
