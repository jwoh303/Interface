package com.koreab2b.mro.seller.mpds.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpDscropProtectDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
}
