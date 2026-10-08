package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGrStockGrDetailPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData); 
}
