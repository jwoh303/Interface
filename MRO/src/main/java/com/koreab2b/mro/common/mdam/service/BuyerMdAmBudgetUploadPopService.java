package com.koreab2b.mro.common.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmBudgetUploadPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public List<Map<String,String>> getBuyerMdAmBudgetUploadPop_v2(Map<String,Object>  formData);
	
	// 업로드
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String saveBuyerMdAmExcelUpload_v2(Map<String,String>  formData, List<Object> gridData);
	
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String saveBuyerMdAmBudgetUpload_v2(Map<String,String>  formData, List<Object> gridData);
}
