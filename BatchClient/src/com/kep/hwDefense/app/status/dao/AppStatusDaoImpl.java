package com.kep.hwDefense.app.status.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;

@SuppressWarnings("unchecked")
public class AppStatusDaoImpl implements AppStatusDao {
	
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
		return this.sqlMapper.queryForList("selectHwDefenseAppStatusIdList");
	}

	@Override
	public void updateAppStatus(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateHwDefenseStatus", pMap);

	}

	@Override
	public Map<String, String> getAppInfo(Map<String, String> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHwDefenseDocInfo", pMap);
	}

	@Override
	public void updateAppCurOrder(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("modifyICOGPASSLN", pMap);
	}

	@Override
	public List<Map<String, String>> getNextAppLine(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("getICOGPASSLNOrderNo", pMap);
	}

	@Override
	public void updateAppFinal(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("modifyICOGDOCU1", pMap);
	}

	@Override
	public void updateAppFinal2(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateAppFinal2", pMap);
	}

	@Override
	public void updateApping(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("modifyICOGDOCU2", pMap);
	}

	@Override
	public void modifyICOGDOCU_PASSSTATUS(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("modifyICOGDOCU_PASSSTATUS", pMap);
	}

	@Override
	public void modifyICOGPASSLN_PASSKN(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("modifyICOGPASSLN_PASSKN", pMap);
	}

	@Override
	public void updatePrCancel(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updatePrCancel", pMap);
	}

	@Override
	public void updateReturnPrBudget(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateReturnPrBudget", pMap);
	}

	@Override
	public List<Map<String, String>> selectPrCancelInfoList(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("selectPrCancelInfoList", pMap);
	}

	@Override
	public void saveAPPR_STATUS_HwDefense(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("saveAPPR_STATUS_HwDefense", pMap);
	}
}
