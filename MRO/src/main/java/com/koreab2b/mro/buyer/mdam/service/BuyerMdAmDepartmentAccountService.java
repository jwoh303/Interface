package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmDepartmentAccountService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerMdAmDepartmentAccountList_v2(Map<String,Object>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String saveBuyerMdAmBudgetDepartmentAccountListPop_v2(Map<String,String>  formData, List<Object> gridData);
	
	public String delBuyerMdAmBudgetDepartmentAccountList_v2(Map<String,String>  formData, List<Object> gridData);
	
}
