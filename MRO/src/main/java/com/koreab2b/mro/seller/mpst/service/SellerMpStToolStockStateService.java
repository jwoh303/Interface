package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

public interface SellerMpStToolStockStateService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
}
