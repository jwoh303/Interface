package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

public interface CommonNoNeMyMenuPopDao {
	// 조회
	public List<Map<String,String>> getCommonNoNeMyMenuAllList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> getCommonNoNeMyMenuList(Map<String,Object> formData);
	
	// 저장
	public String saveCommonNoNeMyMenu(Map<String,String> formData, List<Object> gridData);
	public String saveCommonNoNeMyMenuAjax(Map<String,String> formData);
	
	
	// 저장
	public Map<String, Object> addCommonNoNeMyMenu(Map<String,String> formData);
	
}
