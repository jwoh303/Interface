package com.kep.hanwha.app.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;
import com.kep.hanwha.app.submit.dao.AppSubmitDao;

@SuppressWarnings("unchecked")
public class AppSubmitDaoImpl implements AppSubmitDao{

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;

	public AppSubmitDaoImpl() {
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
			log.error("AppSubmitDao Error : " + CommonUtil.printStackTraceToString(e));
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	@Override
	public List<Map<String, String>> selectIFTargetList() throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaIFTargetList");
	}
	@Override
	public List<Map<String, String>> selectIFAppPrList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaIFAppPrList", pMap);
	}
	@Override
	public Map<String, String> selectIFAppInfo(Map<String, String> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHanWhaIFAppInfo", pMap);
	}
	@Override
	public void insertIfAplSend(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertHanWhaIfAplSend", pMap);
	}
	@Override
	public void insertIfApmSend(Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("insertHanWhaIfApmSend", pMap);
	}
	
	@Override
	public Map<String, Object> selectAppsendList(Map<String, String> pMap) throws Exception {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.sqlMapper.queryForObject("selectHanWhaAppSendList", pMap);
	}
	@Override
	public List<Map<String, String>> selectAppPassList(Map<String, Object> pMap) throws Exception {
		// TODO Auto-generated method stub
		return this.sqlMapper.queryForList("selectHanWhaPassln", pMap);
	}
	@Override
	public List<Map<String, String>> selectAppPassList_refer(Map<String, Object> pMap) throws Exception {
		// TODO Auto-generated method stub
		return this.sqlMapper.queryForList("selectHanWhaPassln_refer", pMap);
	}
	@Override
	public void updateAppSubmitResult(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("updateHanWhaSubmitResult", pMap);
	}
	@Override
	public void updateAppSubmitTrxlResult(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateAppSubmitTrxlResult", pMap);
	}
	
	@Override
	public List<Map<String, String>> selectAtchList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhagetIcomatch", pMap);
	}
	@Override
	public void updateHanWhaIfApmSend(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("updateHanWhaIfApmSend", pMap);
	}
	
	@Override
	public void insertTrxl (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.insert("HanWhaAppSendInsertTrxl", pMap);
	}
	@Override 
	public void insertMail (Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("HanWhaAppMailSend", pMap);
	}
}
