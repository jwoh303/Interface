package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoILJINChoPopService {
	// 조회
	public List<Map<String,String>> getLegacyUserId(Map<String,String>  formData);

	// 품목 재고/비용 정보 확인.
	public Map<String, String> getILJINItemInfo(Map<String,String> pMap);
	
	public List<Map<String,String>> getIljinProject(Map<String,String>  pMap);
}
