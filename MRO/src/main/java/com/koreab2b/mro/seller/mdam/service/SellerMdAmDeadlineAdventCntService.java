package com.koreab2b.mro.seller.mdam.service;

import java.util.List;
import java.util.Map;

public interface SellerMdAmDeadlineAdventCntService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getListPop(Map<String,String>  formData);
	
}
