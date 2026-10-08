package com.kep.hwin.app.send.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class AppSendDaoImpl implements AppSendDao {
	
	private static Logger log	= Logger.getLogger( AppSendDaoImpl.class.getName() );

	private SqlMapClient sqlMapper;
	
	public AppSendDaoImpl() {
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
			log.error("AppSendDaoImpl Error : " + e.getMessage());
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}

	@Override
	public List<Map<String, String>> selectIFTargetList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHwinIFTargetList", pMap);
	}

	@Override
	public List<Map<String, String>> selectIFAppPrList(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectHwinIFAppPrList", pMap);
	}

	@Override
	public Map<String, String> selectIFAppInfo(Map<String, String> pMap)
			throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHwinIFAppInfo", pMap);
	}

	@Override
	public void insertIfAplSend(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertIfAplSend", pMap);
	}

	@Override
	public void insertIfApmSend(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertIfApmSend",pMap);
	}

	@Override
	public Map<String, String> selectHanhwaDocu(Map<String, String> pMap)
			throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHanhwaDocu", pMap);
	}

	@Override
	public List<Map<String, String>> selectHanhwaPassln(Map<String, String> pMap)
			throws Exception {
		return this.sqlMapper.queryForList("selectHanhwaPassln", pMap);
	}

	@Override
	public void updateIFTargetFlag(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateIFTargetFlag", pMap);
	}

}
