package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClClosingInfoDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> getAgentClosingInfoDown(Map<String,String> formData);
	
}
