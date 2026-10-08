package com.koreab2b.mro.common.none.dao;

import java.util.List;
import java.util.Map;

public interface CommonNoNeBuyerMyMenuPopDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectMyMenuList(Map<String,String> formData);
	
	// 저장
	public String insertCommonNoNeBuyerMyMenu(Map<String,String> pMap);
}
