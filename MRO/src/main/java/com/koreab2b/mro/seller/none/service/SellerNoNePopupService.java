package com.koreab2b.mro.seller.none.service;

import java.util.List;
import java.util.Map;

public interface SellerNoNePopupService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// 읽음 처리
	public String saveSellerNoNePopupRead(Map<String, String> pMap);
	

}
