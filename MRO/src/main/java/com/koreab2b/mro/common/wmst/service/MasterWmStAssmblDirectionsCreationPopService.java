package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

public interface MasterWmStAssmblDirectionsCreationPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	public List<Map<String,String>> getList2(Map<String,Object>  formData);
	
	public List<Map<String,String>> getChangeList(Map<String,Object>  formData);
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
}
