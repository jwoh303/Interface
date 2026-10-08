package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmBudgetService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerMdAmBudgetList_v2(Map<String,Object>  formData);
	
	// 이력 조회
	public List<Map<String,String>> getHistList(Map<String,String>  formData);
	public List<Map<String,String>> excelBuyerMdAmBudgetHistList_v2(Map<String,Object>  formData);
	

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
