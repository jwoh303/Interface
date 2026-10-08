package com.kep.kumh.pr.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;


@SuppressWarnings("unchecked")
public class PrSubmitDaoImpl implements PrSubmitDao{
	private SqlMapClient sqlMapper;
	private Logger log	= Logger.getLogger( this.getClass().getName() );

	public PrSubmitDaoImpl() {
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
	public List<Map<String, String>> selectTargetList() throws Exception {
		return sqlMapper.queryForList("selectKumhTargetList");
	}

	@Override
	public List<Map<String, String>> selectPrList(Map<String, String> map) throws Exception {
		return sqlMapper.queryForList("selectKumhPrList", map);
	}

	@Override
	public void updateResultData(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateKumhResultData", pMap);
		
		if(pMap.get("ZRTCD").equals("Y")&&pMap.get("STAU").equals("I")) {
			this.sqlMapper.update("updateLegecyPoInfo", pMap);
			this.sqlMapper.update("insertKumhIfProgress", pMap);
		}
		
	}

	@Override
	public void insertMail(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("KumhAppMailSend", pMap);
	}

	@Override
	public List<Map<String, String>> selectMailInfo(Map<String, String> pMap) throws Exception {
		return sqlMapper.queryForList("selectMailInfo", pMap);
	}


}
