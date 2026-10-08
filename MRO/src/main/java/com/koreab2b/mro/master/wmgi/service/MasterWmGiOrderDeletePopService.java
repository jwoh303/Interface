package com.koreab2b.mro.master.wmgi.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGiOrderDeletePopService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 조회
	public List<Map<String,String>> getPop(Map<String, String> pMap);
	
	public String  updateSelectedData(Map<String, String> formData ,List<Object> gridData);
}
