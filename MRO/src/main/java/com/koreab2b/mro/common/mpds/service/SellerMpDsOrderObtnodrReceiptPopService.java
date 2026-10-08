package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface SellerMpDsOrderObtnodrReceiptPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	//수주접수
	public String regDsData(Map<String, String> formData);
}
