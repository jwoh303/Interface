package com.kep.hwDefense.app.submit.dao;

import java.util.List;
import java.util.Map;

public interface AppSubmitDao {

	public List<Map<String, Object>> selectAppResendList() throws Exception;
	
	public List<Map<String, String>> selectAppPassList(Map<String, String> pMap) throws Exception;
	
	public void updateAppSubmitResult(Map<String, String> pMap) throws Exception;

	public List<Map<String, String>> selectHanhwaAttFileList(Map<String, Object> apmData) throws Exception;
}