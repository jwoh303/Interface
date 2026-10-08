package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGiMultiHubReleaseTransPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData);
	
	// 간선다중출고지시
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);
}