package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsCatalogDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 엑셀 조회
	public List<Map<String,String>> selecExceltList(Map<String,Object> param);
	
	// 카테고리 속성건수 조회
	public String getCategoriAttributeListCount(Map<String,String> formData);
	
	// 카테고리 속성 조회
	public List<Map<String,String>> getCategoriAttributeList(Map<String,String> formData);

}
