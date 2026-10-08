package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoDeliveryPunchOutProgressService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 납기지연조회
	public List<Map<String,String>> getDelayList(Map<String,String>  formData);	
	
}
