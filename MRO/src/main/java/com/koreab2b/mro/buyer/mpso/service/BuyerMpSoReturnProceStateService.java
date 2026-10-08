package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoReturnProceStateService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
