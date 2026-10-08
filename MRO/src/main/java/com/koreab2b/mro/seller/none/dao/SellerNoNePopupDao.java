package com.koreab2b.mro.seller.none.dao;

import java.util.List;
import java.util.Map;

public interface SellerNoNePopupDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	// 읽음 저장
	public String insertSellerNoNePopupRead(Map<String, String> formData);

	
}
