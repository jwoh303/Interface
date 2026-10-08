package com.kep.hanwhaaero.app.submit.dao;

import java.io.Reader;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.ibatis.common.resources.Resources;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.ibatis.sqlmap.client.SqlMapClientBuilder;
import com.kep.common.CommonProperty;
import com.kep.common.CommonUtil;

public class AppSubmitDaoImpl implements AppSubmitDao {

	
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
		return this.sqlMapper.queryForList("selectHanWhaAeroIFTargetList");
	}

	@Override
	public List<Map<String, String>> selectIFAppPrList(Map<String, String> target) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaAeroIFAppPrList", target);
	}

	@Override
	public Map<String, String> selectIFAppInfo(Map<String, String> target) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("selectHanWhaAeroIFAppInfo", target);
	}

	@Override
	public List<Map<String, String>> selectAtchList(Map<String, String> appData) throws Exception {
		return this.sqlMapper.queryForList("HanWhaAerogetIcomatch", appData);
	}

	@Override
	public void insertIfAplSend(Map<String, String> appData) throws Exception {
		this.sqlMapper.insert("insertHanWhaAeroIfAplSend", appData);
		
	}

	@Override
	public void insertIfApmSend(Map<String, String> appData) throws Exception {
		this.sqlMapper.insert("insertHanWhaAeroIfApmSend", appData);
	}

	@Override
	public Map<String, Object> selectAppsendList(Map<String, String> appData) throws Exception {
		return (Map<String, Object>) this.sqlMapper.queryForObject("selectHanWhaAeroAppSendList", appData);
	}

	@Override
	public List<Map<String, String>> selectAppPassList(Map<String, Object> apmData) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaAeroPassln", apmData);
	}

	@Override
	public List<Map<String, String>> selectAppPassList_refer(Map<String, Object> apmData) throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaAeroPassln_refer", apmData);
	}

	@Override
	public void updateAppSubmitResult(Map<String, Object> apmData) throws Exception {
		this.sqlMapper.update("updateHanWhaAeroSubmitResult", apmData);
		
	}

	@Override
	public void updateAppSubmitTrxlResult(Map<String, String> target) throws Exception {
		this.sqlMapper.update("updateAeroAppSubmitTrxlResult", target);
	}

	@Override
	public void updateHanWhaIfApmSend(Map<String, Object> apmData) throws Exception {
		this.sqlMapper.update("updateHanWhaAeroIfApmSend", apmData);
		
	}


	@Override
	public void insertMail(Map<String, String> target) throws Exception {
		this.sqlMapper.insert("HanWhaAeroAppMailSend", target);
	}
	
	//---------------------------------- 상태값

	@Override
	public List<Map<String, String>> getAppList() throws Exception {
		return this.sqlMapper.queryForList("selectHanWhaAeroAppStatusIdList");
	}

	@Override
	public Map<String, String> getAppInfo(Map<String, Object> pMap) throws Exception {
		return (Map<String, String>) this.sqlMapper.queryForObject("HanWhaAerogetAppInfo", pMap);
	}

	@Override
	public void updateAppCurOrder(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeromodifyICOGPASSLN", pMap);
	}

	@Override
	public List<Map<String, String>> getNextAppLine(Map<String, String> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaAerogetICOGPASSLNOrderNo", pMap);
	}

	@Override
	public List<Map<String, String>> selectPrCancelInfoList(Map<String, Object> pMap) throws Exception {
		return this.sqlMapper.queryForList("HanWhaAeroselectPrCancelInfoList", pMap);
	}

	@Override
	public void updatePrCancel(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeroupdatePrCancel", pMap);
	}

	@Override
	public void updateApping(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeromodifyICOGDOCU2", pMap);
	}

	@Override
	public void updateApl(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeromodifyAPL", pMap);
	}

	@Override
	public void updateAppStatus(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeroupdateHwinAppStatus", pMap);
	}

	@Override
	public void updateAppFinal2(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeroupdateAppFinal2", pMap);
	}

	@Override
	public void modifyICOGDOCU_PASSSTATUS(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeromodifyICOGDOCU_PASSSTATUS", pMap);
	}

	@Override
	public void modifyICOGPASSLN_PASSKN(Map<String, Object> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeromodifyICOGPASSLN_PASSKN", pMap);
	}

	@Override
	public void updateReturnPrBudget(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("HanWhaAeroupdateReturnPrBudget", pMap);
	}


	@Override
	public void updateAppStatus_ChangeLine(Map<String, String> pMap) throws Exception {
		this.sqlMapper.update("updateAeroAppStatus_ChangeLine", pMap);
		}
}
