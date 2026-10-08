package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmCategoryPCODao {

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getCategoryPathPCO(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getRqUserInfo(Map<String,String> formData);
	// 저장
	public String saveBuyerMdCmRqdtTemp(Map<String,String> formData);
}
