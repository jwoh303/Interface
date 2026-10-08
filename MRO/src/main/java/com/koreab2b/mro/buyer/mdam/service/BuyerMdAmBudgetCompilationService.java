package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmBudgetCompilationService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerMdAmBudgetCompilationList_v2(Map<String,Object>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String saveBuyerMdAmBudgetCompilationList_v2(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);	
	public String delBuyerMdAmBudgetCompilationList_v2(Map<String,String>  formData, List<Object> gridData);
	
}
