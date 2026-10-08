package com.koreab2b.mro.seller.mdct.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdCtUserRegRequestReceiptDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData);
}
