package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;

import java.util.Map;

public interface BuyerMdCmUniformSearchService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
}
