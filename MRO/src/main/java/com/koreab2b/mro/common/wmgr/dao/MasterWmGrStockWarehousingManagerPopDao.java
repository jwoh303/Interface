package com.koreab2b.mro.common.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrStockWarehousingManagerPopDao {

	// 상단조회 
	public List<Map<String,String>> selectPop(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	//저장
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);

}
