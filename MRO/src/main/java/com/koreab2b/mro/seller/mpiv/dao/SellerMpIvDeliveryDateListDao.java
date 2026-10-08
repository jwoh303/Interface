package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryDateListDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 삭제
	public String updateSellerMpIvDeliveryDateReg(Map<String,String> pMap);
}
