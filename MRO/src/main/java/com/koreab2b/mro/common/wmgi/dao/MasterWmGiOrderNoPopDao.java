package com.koreab2b.mro.common.wmgi.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGiOrderNoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	//출고지시 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
