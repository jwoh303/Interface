package com.koreab2b.mro.master.wmst.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmStStockMovemntReleaseDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 리스트 조회
	public List<Map<String, String>> selectWarehouseList(Map<String, String> param);
		
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

}
