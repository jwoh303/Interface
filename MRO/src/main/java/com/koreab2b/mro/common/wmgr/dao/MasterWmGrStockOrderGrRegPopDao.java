package com.koreab2b.mro.common.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrStockOrderGrRegPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
