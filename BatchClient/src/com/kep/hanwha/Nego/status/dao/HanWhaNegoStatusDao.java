package com.kep.hanwha.Nego.status.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

public class HanWhaNegoStatusDao {

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public HanWhaNegoStatusDao() {
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
		return this.sqlMapper.queryForList("selectHanWhaNegoAppStatusIdList");
	}
	
	
	public Map<String, String> getAppInfo (Map<String,Object> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("HanWhaNegogetAppInfo", pMap);
	}
	
	
	public void updateAppCurOrder (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegomodifyICOGPASSLN", pMap);
	}
	
	
	public List<Map<String, String>> getNextAppLine(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaNegogetICOGPASSLNOrderNo", pMap);
	}
	
	
	public List<Map<String, String>> selectNegoCancelInfoList(Map<String,Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaselectNegoCancelInfoList", pMap);
	}
	
	
	public void updateNegoCancel (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegoupdateCancel", pMap);
	}
	
	
	public void updateApping (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegomodifyICOGDOCU2", pMap);
	}
	
	public void updateApl (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegomodifyAPL", pMap);
	}
	
	
	public void updateAppStatus (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegoupdateHwinAppStatus", pMap);
	}
	
	
	public void updateAppFinal2 (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegoupdateAppFinal2", pMap);
	}
	
	
	public void modifyICOGDOCU_PASSSTATUS (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegomodifyICOGDOCU_PASSSTATUS", pMap);
	}
	
	public void modifyICOGPASSLN_PASSKN (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaNegomodifyICOGPASSLN_PASSKN", pMap);
	}
	public void HANHWA_RQDT_CONFIRM (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HANHWA_RQDT_CONFIRM", pMap);
	}
	public void HANHWA_RQDT_NEGO (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HANHWA_RQDT_CONFIRM", pMap);
	}
	public void updateNegoStatus_ChangeLine (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateNegoStatus_ChangeLine", pMap);
	}
}
