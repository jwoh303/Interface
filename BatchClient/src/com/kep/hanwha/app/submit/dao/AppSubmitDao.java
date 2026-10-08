package com.kep.hanwha.app.submit.dao;

import java.util.List;
import java.util.Map;

public interface AppSubmitDao {

	public List<Map<String, String>> selectIFTargetList() throws Exception;
	
	public List<Map<String, String>> selectIFAppPrList(Map<String, String> pMap) throws Exception;
	
	public Map<String, String> selectIFAppInfo(Map<String, String> pMap) throws Exception;

	public void insertIfAplSend(Map<String, String> pMap) throws Exception;
	
	public void insertIfApmSend(Map<String, String> pMap) throws Exception;
	
	public Map<String, Object> selectAppsendList(Map<String, String> pMap) throws Exception;
	
	public List<Map<String, String>> selectAppPassList(Map<String, Object> pMap) throws Exception;
	public List<Map<String, String>> selectAppPassList_refer(Map<String, Object> pMap) throws Exception;
	
	public void updateAppSubmitResult(Map<String, Object> pMap) throws Exception;
	public void updateAppSubmitTrxlResult(Map<String, String> pMap) throws Exception;
	
	public List<Map<String, String>> selectAtchList(Map<String, String> pMap) throws Exception;

	public void updateHanWhaIfApmSend(Map<String, Object> pMap) throws Exception;
	
	public void insertTrxl (Map<String, Object> pMap) throws Exception;
	
	public void insertMail (Map<String, String> pMap) throws Exception;
}
