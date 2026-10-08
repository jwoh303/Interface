package com.koreab2b.mro.seller.mpst.service;

import java.util.List;
import java.util.Map;

public interface SellerMpStDeliveryRecordService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
}
