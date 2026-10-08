package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmBudgetDepartmentService {
	public List<Map<String,String>> getBuyerMdAmBudgetDepartmentListAll_v2(Map<String,Object>  formData);
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerMdAmBudgetDepartmentList_v2(Map<String,Object>  formData);
	
	//삭제
	public String delBuyerMdAmBudgetDepartmentList_v2(Map<String,String>  formData, List<Object> gridData);
	//저장
	public String saveBuyerMdAmBudgetDepartmentList_v2(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public String saveBuyerMdAmDepartmentListPop_v2(Map<String,String>  formData, List<Object> gridData);
	
	public String saveBuyerMdAmBudgetDepartmentListPop_v2(Map<String,String>  formData, List<Object> gridData);
	
	public String delBuyerMdAmBudgetDepartmentConList_v2(Map<String,String>  formData, List<Object> gridData);
}
