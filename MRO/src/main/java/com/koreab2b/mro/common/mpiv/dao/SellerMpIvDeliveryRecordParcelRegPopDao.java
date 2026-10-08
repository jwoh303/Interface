package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryRecordParcelRegPopDao {

	// 조회
	public List<Map<String,String>> selectNew(Map<String,String> formData);
	
	// 송장 업데이트
	public String saveParcel(Map<String,String>  formData);
	
}
