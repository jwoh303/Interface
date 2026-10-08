package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryDelayStateDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);
	
	// 저장
	public String updateSellerMpIvDeliveryDelayState(Map<String,String> pMap);
}
