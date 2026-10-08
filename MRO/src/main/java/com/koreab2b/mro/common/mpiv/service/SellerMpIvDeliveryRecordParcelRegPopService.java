package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryRecordParcelRegPopService {
	
	// 송장정보 저장
	public String setParcel(Map<String, String> formData);
	
	// 저장된 정보 조회
	public List<Map<String,String>> getNewParcel(Map<String,String>  formData);


}
