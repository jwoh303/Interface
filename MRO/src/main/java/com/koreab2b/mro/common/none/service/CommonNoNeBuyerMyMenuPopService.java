package com.koreab2b.mro.common.none.service;

import java.util.List;
import java.util.Map;

public interface CommonNoNeBuyerMyMenuPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 나의 메뉴 목록 조회
	public List<Map<String,String>> getMyMenuList(Map<String,String>  formData);
	
	// 저장
	public String saveCommonNoNeBuyerMyMenu(Map<String,String> pMap) ;
}
