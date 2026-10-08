package com.koreab2b.mro.common.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmPromotionMarketCatalogSelPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getCategorySelPop(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getSgInfo(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getCategInfo(Map<String,String> formData);
	// 고객사예외조회
	public List<Map<String,String>> getBuyerSgInfo(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getNewUserInfo(Map<String,String> formData);
	// 주문불가능자리스트조회
	public List<Map<String,String>> getOrderUserInfo(Map<String,String> formData);
	
	public Map<String, String> getSmartSgInfo(Map<String, String> formData);
	
	public List<String> getSmartSgIdInfo(Map<String, Object> formData);
}
