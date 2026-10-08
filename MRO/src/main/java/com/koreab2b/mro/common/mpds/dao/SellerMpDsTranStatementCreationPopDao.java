package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpDsTranStatementCreationPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	//송장생성
	public String invoiceOrderInfo(Map<String, String> formData);	
}
