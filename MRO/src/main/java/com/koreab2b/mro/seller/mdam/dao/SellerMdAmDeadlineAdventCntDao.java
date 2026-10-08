package com.koreab2b.mro.seller.mdam.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdAmDeadlineAdventCntDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectListPop(Map<String,String> formData);
	
}
