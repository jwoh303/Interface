package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvObtnodrReceiptDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	public List<Map<String,String>> selectExcelList(Map<String,String> formData);
	
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptList_v2(Map<String,Object> formData);
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptMultiList_v2(Map<String,Object> formData);
	
	
}
