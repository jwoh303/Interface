package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface SellerMpDsTranStatementCreationPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	//송장생성
	public String invoiceOrderInfo(Map<String, String> formData);
}
