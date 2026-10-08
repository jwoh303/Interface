package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

public interface SellerMpStRecmndOrderReceiptService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 날짜 파라미터 포함 조회 (신규)
	public List<Map<String,String>> getListWithDate(Map<String,String> formData);
}
