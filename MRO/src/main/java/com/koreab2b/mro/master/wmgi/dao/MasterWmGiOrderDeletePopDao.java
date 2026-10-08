package com.koreab2b.mro.master.wmgi.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGiOrderDeletePopDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	//조회
    public List<Map<String,String>> selectListPop(Map<String, String> pMap);
    
	// 삭제
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
