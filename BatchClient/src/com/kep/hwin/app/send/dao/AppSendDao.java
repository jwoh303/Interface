package com.kep.hwin.app.send.dao;

import java.util.List;
import java.util.Map;

public interface AppSendDao {
	
	public List<Map<String, String>> selectIFTargetList(Map<String, String> pMap) throws Exception;

	public List<Map<String, String>> selectIFAppPrList(Map<String, String> pMap) throws Exception;
	
	public Map<String, String> selectIFAppInfo(Map<String, String> pMap) throws Exception;
	
	public void insertIfAplSend(Map<String, String> pMap) throws Exception;
	
	public void insertIfApmSend(Map<String, String> pMap) throws Exception;
	
	public Map<String, String> selectHanhwaDocu(Map<String, String> pMap) throws Exception;
	
	public List<Map<String, String>> selectHanhwaPassln(Map<String, String> pMap) throws Exception;
	
	public void updateIFTargetFlag(Map<String, String> pMap) throws Exception;
}
