package com.kep.quratis.dao;

import java.util.List;
import java.util.Map;

public interface AppStatusDao {
	
	public List<Map<String, String>> getAppList() throws Exception;
	
	public void UpdateAppStatus(Map<String, String> iMap) throws Exception;
	
	
}
