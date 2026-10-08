package com.kep.hanwha.app.status.dao;

import java.util.List;
import java.util.Map;

public interface AppStatusDao {

	public List<Map<String,String>> getAppList () throws Exception;
	
	public Map<String,String> getAppInfo (Map<String, Object> pMap) throws Exception;
	
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
	
	public void insertTrxl (Map<String, String> pMap) throws Exception;
	
	public void updateAppStatus_ChangeLine (Map<String, String> pMap) throws Exception;
	
}
