package com.kep.hwin.app.status.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.stw.kep.ws.service.M2KEP0002M2016.T_APPR_STATUS_IN_STEP;

@SuppressWarnings("unchecked")
public class AppStatusDaoImpl implements AppStatusDao {
	
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
	public SqlMapClient getSqlMapClient() {
		return this.sqlMapper;
	}

	@Override
	public List<Map<String, String>> getAppList() throws Exception {
		return this.sqlMapper.queryForList("selectHwinAppStatusIdList");
	}

	@Override
	public void updateAppStatus(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateHwinAppStatus", pMap);
	}

	@Override
	public Map<String, String> getAppInfo(Map<String, String> pMap)
			throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHwinAppDocInfo", pMap);
	}

	@Override
	public void updateAppCurOrder(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("modifyICOGPASSLN", pMap);
	}

	@Override
	public List<Map<String, String>> getNextAppLine(Map<String, String> pMap)
			throws Exception {
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
	public void modifyICOGDOCU_PASSSTATUS(Map<String, String> pMap)
			throws Exception {
		this.sqlMapper.update("modifyICOGDOCU_PASSSTATUS", pMap);
	}

	@Override
	public void modifyICOGPASSLN_PASSKN(Map<String, String> pMap)
			throws Exception {
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
	public void saveAPPR_STATUS(T_APPR_STATUS_IN_STEP item) throws Exception  {
		this.sqlMapper.update("saveAPPR_STATUS", item);
	}

}
