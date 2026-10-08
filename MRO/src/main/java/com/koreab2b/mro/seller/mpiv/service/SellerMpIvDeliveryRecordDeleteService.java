package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryRecordDeleteService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	
	// 삭제
	public String saveSellerMpIvDeliveryRecordDelete(Map<String,String>  pMap);
		
	
	
}
