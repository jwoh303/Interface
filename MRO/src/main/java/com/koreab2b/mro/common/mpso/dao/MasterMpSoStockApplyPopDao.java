package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoStockApplyPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	// 조회(상세)
	public List<Map<String,String>> selectListDetail(Map<String,Object> formData);

	//저장
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);
}
