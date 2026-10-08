package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvObtnodrReceiptService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public List<Map<String,String>> getExcelList(Map<String,String>  formData);
	
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptList_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getSellerMpIvObtnodrReceiptMultiList_v2(Map<String,Object>  formData);
}
