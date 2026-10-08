package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfDivsnPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectDivsnList(Map<String,String> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
		
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
