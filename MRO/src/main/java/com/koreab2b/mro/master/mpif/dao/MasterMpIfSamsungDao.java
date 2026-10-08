package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfSamsungDao {

	public List<Map<String, String>> getSamsungPoList(Map<String, Object> pMap);
	
	public String insertMasterMpifSamsungPoReturn(Map<String, String> formData, List<Object> gridData);
}