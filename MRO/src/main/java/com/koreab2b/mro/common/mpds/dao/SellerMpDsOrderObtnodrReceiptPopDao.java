package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpDsOrderObtnodrReceiptPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	//수주접수
	public String regDsData(Map<String, String> formData);	

}
