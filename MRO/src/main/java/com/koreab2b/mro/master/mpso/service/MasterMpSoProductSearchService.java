package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoProductSearchService {

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 리스트조회
	public List<Map<String,String>> getRootTreeList(Map<String,Object>  param);
	
	// 리스트조회
	public List<Map<String,String>> getChildTreeList(Map<String,Object>  param);
	
	// 장바구니 담기
	public String insertWmsCart(Map<String,String>  formData, List<Object> gridData);
	
}
