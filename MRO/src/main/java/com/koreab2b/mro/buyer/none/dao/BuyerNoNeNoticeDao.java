package com.koreab2b.mro.buyer.none.dao;

import java.util.List;
import java.util.Map;

public interface BuyerNoNeNoticeDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 상세
	public Map<String,String> selectDetail(Map<String,String> formData);
}
