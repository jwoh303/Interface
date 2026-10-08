package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryRecordDeleteDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> pMap);

	// 삭제
	public String saveSellerMpIvDeliveryRecordDelete(Map<String,String> pMap);
	
}
