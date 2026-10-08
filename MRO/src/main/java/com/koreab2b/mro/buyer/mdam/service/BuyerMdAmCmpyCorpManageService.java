package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmCmpyCorpManageService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 조회
		public List<Map<String,String>> getPassList(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData);
}
