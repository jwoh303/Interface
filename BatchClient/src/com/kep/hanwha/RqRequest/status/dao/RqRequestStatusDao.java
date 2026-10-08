package com.kep.hanwha.RqRequest.status.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class RqRequestStatusDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public RqRequestStatusDao() {
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
			throw new RuntimeException("Something bad happened while building the SqlMapClient instance." + e, e);
		}
	}
	
	
	public List<Map<String, String>> getAppList() throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaRqAppStatusIdList");
	}
	
	
	public Map<String, String> getAppInfo (Map<String,Object> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("HanWhaRqgetAppInfo", pMap);
	}
	
	
	public void updateAppCurOrder (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqmodifyICOGPASSLN", pMap);
	}
	
	
	public List<Map<String, String>> getNextAppLine(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaRqgetICOGPASSLNOrderNo", pMap);
	}
	
	
	public List<Map<String, String>> selectRqCancelInfoList(Map<String,Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaselectRqCancelInfoList", pMap);
	}
	
	
	public void updateRqCancel (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqupdateCancel", pMap);
	}
	
	
	public void updateApping (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqmodifyICOGDOCU2", pMap);
	}
	
	public void updateApl (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqmodifyAPL", pMap);
	}
	
	
	public void updateAppStatus (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqupdateHwinAppStatus", pMap);
	}
	
	
	public void updateAppFinal2 (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqupdateAppFinal2", pMap);
	}
	
	
	public void modifyICOGDOCU_PASSSTATUS (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqmodifyICOGDOCU_PASSSTATUS", pMap);
	}
	
	public void modifyICOGPASSLN_PASSKN (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaRqmodifyICOGPASSLN_PASSKN", pMap);
	}
	public void updateRqStatus_ChangeLine (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateRqStatus_ChangeLine", pMap);
	}
}
