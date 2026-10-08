package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvObtnodrMultiReceiptDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	public List<Map<String,String>> selectExcelList(Map<String,String> formData);
	//수주접수 저장
	public String saveSellerMpIvObtnodrMultiReceiptList(Map<String, String> pMap, List<Object> pList);
	
}
