package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmPromotionMarketCatalogSelPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String>  formData);
	// 조회
	public List<Map<String,String>> getSgInfo(Map<String,String>  formData);
	// 조회
	public List<Map<String,String>> getCategInfo(Map<String,String>  formData);
	// 고객사 예외조회
	public List<Map<String,String>> getBuyerSgInfo(Map<String,String>  formData);
	// 2016년 이전 조회
	public List<Map<String,String>> getNewUserInfo(Map<String,String>  formData);
	// 주문불가능자리스트조회
	public List<Map<String,String>> getOrderUserInfo(Map<String,String>  formData);
	
	public Map<String, String> getSmartSgInfo(Map<String, String> pMap);
	
	public List<String> getSmartSgIdInfo(Map<String, Object> pMap);	
}
