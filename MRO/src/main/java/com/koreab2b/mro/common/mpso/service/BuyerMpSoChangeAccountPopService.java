package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoChangeAccountPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getList_v2(Map<String,String>  formData);
	
	// 저장
	public String saveBuyerMpSoChangeAccountPop(Map<String,String> formData);
}