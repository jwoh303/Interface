package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvObtnodrMultiReceiptService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public List<Map<String,String>> getExcelList(Map<String,String>  formData);
	// 수주접수 저장
	public String saveSellerMpIvObtnodrMultiReceiptList(Map<String, String> pMap, List<Object> pList);
	
}
