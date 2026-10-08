package com.koreab2b.mro.seller.mpst.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpStRecmndOrderReceiptDao {
	// 조회 (기존)
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 날짜 파라미터 포함 조회 (신규)
	public List<Map<String,String>> selectListWithDate(Map<String,String> formData);
}
