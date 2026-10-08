package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmGoodsLineStateService {

	// 조회조건 - userList 조회
	public List<Map<String,String>> getUserList(Map<String,String> formData);
	
	public List<Map<String,String>> getList(Map<String,String>  formData);
}
