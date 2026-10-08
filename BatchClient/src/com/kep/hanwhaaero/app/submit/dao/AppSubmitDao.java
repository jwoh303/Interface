package com.kep.hanwhaaero.app.submit.dao;

import java.util.List;
import java.util.Map;

public interface AppSubmitDao {

	public List<Map<String, String>> selectIFTargetList() throws Exception;

	public List<Map<String, String>> selectIFAppPrList(Map<String, String> target) throws Exception;

	public Map<String, String> selectIFAppInfo(Map<String, String> target) throws Exception;

	public List<Map<String, String>> selectAtchList(Map<String, String> appData) throws Exception;

	public void insertIfAplSend(Map<String, String> appData) throws Exception;

	public void insertIfApmSend(Map<String, String> appData) throws Exception;

	public Map<String, Object> selectAppsendList(Map<String, String> appData) throws Exception;

	public List<Map<String, String>> selectAppPassList(Map<String, Object> apmData)  throws Exception;

	public List<Map<String, String>> selectAppPassList_refer(Map<String, Object> apmData) throws Exception;

	public void updateAppSubmitResult(Map<String, Object> apmData) throws Exception;

	public void updateAppSubmitTrxlResult(Map<String, String> target) throws Exception;

	public void updateHanWhaIfApmSend(Map<String, Object> apmData) throws Exception;

	public void insertMail(Map<String, String> target) throws Exception;

	
	//상태값 -----------------------
	public List<Map<String, String>> getAppList() throws Exception;

	public Map<String, String> getAppInfo(Map<String, Object> pMap) throws Exception;
	
	public void updateAppCurOrder (Map<String, String> pMap) throws Exception;
	
	public List<Map<String,String>> getNextAppLine (Map<String, String> pMap) throws Exception;
	
	public List<Map<String,String>> selectPrCancelInfoList (Map<String, Object> pMap) throws Exception;
	
	public void updatePrCancel (Map<String, String> pMap) throws Exception;
	
	public void updateApping (Map<String, String> pMap) throws Exception;
	
	public void updateApl (Map<String, String> pMap) throws Exception;
	
	public void updateAppStatus (Map<String, Object> pMap) throws Exception;
	
	public void updateAppFinal2 (Map<String, Object> pMap) throws Exception;
	
	public void modifyICOGDOCU_PASSSTATUS (Map<String, Object> pMap) throws Exception;
	
	public void modifyICOGPASSLN_PASSKN (Map<String, Object> pMap) throws Exception;
	
	public void updateReturnPrBudget (Map<String, String> pMap) throws Exception;
	
	public void updateAppStatus_ChangeLine (Map<String, String> pMap) throws Exception;
	
	

}
