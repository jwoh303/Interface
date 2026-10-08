package com.koreab2b.mro.common.wmst.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmStAssmblDirectionsCreationPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	public List<Map<String,String>> selectList2(Map<String,Object> formData);
	
	public List<Map<String,String>> getChangeList(Map<String,Object> formData);
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
}
