package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsCatalogService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 엑셀 리스트 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> param);
	
	//카테고리 속성건수 조회
	public String getCategoriAttributeListCount(Map<String, String> formData);
	
	// 카테고리 속성 조회
	public List<Map<String,String>> getCategoriAttributeList(Map<String,String> formData);

}
