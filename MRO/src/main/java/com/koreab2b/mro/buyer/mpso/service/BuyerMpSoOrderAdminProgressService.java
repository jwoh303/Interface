package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoOrderAdminProgressService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 엑셀조회
	public List<Map<String,String>> getExcelList(Map<String,String>  formData);
	// 부서별집계
	public List<Map<String,String>> getOrderDepttList(Map<String,String>  formData);	
	// 부서별집계
	public List<Map<String,String>> getOrderAgentList(Map<String,String>  formData);
}
