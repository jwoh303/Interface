package com.koreab2b.mro.common.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrStockOrderManagerPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectPop(Map<String,String> formData);
	
	//발주삭제
	public String deleteMasterWmGrStockOrderManagerPopPoDel(Map<String,String>  formData, List<Object> gridData);
	
	//단가변경
	public String deleteMasterWmGrStockOrderManagerPopPriceChange(Map<String,String>  formData, List<Object> gridData);
	
	//공급사변경
	public String deleteMasterWmGrStockOrderManagerPopAgentChange(Map<String,String>  formData, List<Object> gridData); 
}
