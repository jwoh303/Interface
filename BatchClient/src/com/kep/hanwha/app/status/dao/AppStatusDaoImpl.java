package com.kep.hanwha.app.status.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class AppStatusDaoImpl implements AppStatusDao{

	private Logger log	= Logger.getLogger( this.getClass().getName() );
	private SqlMapClient sqlMapper;
	
	public AppStatusDaoImpl() {
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
	
	@Override
	public List<Map<String, String>> getAppList() throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaAppStatusIdList");
	}
	
	@Override
	public Map<String, String> getAppInfo (Map<String,Object> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("HanWhagetAppInfo", pMap);
	}
	
	@Override
	public void updateAppCurOrder (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhamodifyICOGPASSLN", pMap);
	}
	
	@Override
	public List<Map<String, String>> getNextAppLine(Map<String,String> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhagetICOGPASSLNOrderNo", pMap);
	}
	
	@Override
	public List<Map<String, String>> selectPrCancelInfoList(Map<String,Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaselectPrCancelInfoList", pMap);
	}
	
	@Override
	public void updatePrCancel (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaupdatePrCancel", pMap);
	}
	
	@Override
	public void updateApping (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhamodifyICOGDOCU2", pMap);
	}
	@Override
	public void updateApl (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhamodifyAPL", pMap);
	}
	
	@Override
	public void updateAppStatus (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaupdateHwinAppStatus", pMap);
	}
	
	@Override
	public void updateAppFinal2 (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaupdateAppFinal2", pMap);
	}
	
	@Override
	public void modifyICOGDOCU_PASSSTATUS (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhamodifyICOGDOCU_PASSSTATUS", pMap);
	}
	@Override
	public void modifyICOGPASSLN_PASSKN (Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhamodifyICOGPASSLN_PASSKN", pMap);
	}
	@Override
	public void updateReturnPrBudget (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaupdateReturnPrBudget", pMap);
	}
	@Override
	public void insertTrxl (Map<String, String> pMap) throws Exception {
		this.sqlMapper.insert("HanWhaAppInsertTrxl", pMap);
	}
	@Override
	public void updateAppStatus_ChangeLine (Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateAppStatus_ChangeLine", pMap);
	}
}
