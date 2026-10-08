package com.kep.taxbill.dao;

import java.util.List;
import java.util.Map;

public interface TaxAccountErpDao {

	public List<Map<String, String>> selectTargetList() throws Exception;
	
	public List<Map<String, Object>> selectTaccountIfGLList(Map<String, String> pMap) throws Exception;
	
	public List<Map<String, Object>> selectTaccountIfHisList(Map<String, String> pMap) throws Exception;
}