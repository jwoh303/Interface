package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpRqQuotReqDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);
}
