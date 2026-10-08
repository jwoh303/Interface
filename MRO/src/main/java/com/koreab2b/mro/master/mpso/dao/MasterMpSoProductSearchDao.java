package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoProductSearchDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 리스트 조회
	public List<Map<String,String>> selectRootTreeList(Map<String,Object> param);
	
	// 리스트 조회
	public List<Map<String,String>> selectChildTreeList(Map<String,Object> param);
	
	// 장바구니 담기
	public String insertWmsCart(Map<String,String>  formData, List<Object> gridData);
	
}
