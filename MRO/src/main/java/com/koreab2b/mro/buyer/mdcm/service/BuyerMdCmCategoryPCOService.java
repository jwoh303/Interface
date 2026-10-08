package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmCategoryPCOService {
	// 상품조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 상품조회
	public List<Map<String,String>> getCategoryPathPCO(Map<String,String>  formData);
	// 견적의뢰 사용자
	public List<Map<String,String>> getRqUserInfo(Map<String,String>  formData);
	// 견적임시저장
	public String saveBuyerMdCmRqdtTemp(Map<String,String>  formData);
}
