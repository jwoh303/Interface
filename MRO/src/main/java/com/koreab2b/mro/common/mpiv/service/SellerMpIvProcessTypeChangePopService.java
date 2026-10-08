package com.koreab2b.mro.common.mpiv.service;

import java.util.Map;

public interface SellerMpIvProcessTypeChangePopService {
	
	// 거래유형 변경 요청
	public String saveSellerMpIvProcessTypeChangeReq(Map<String,String>  formData);
}
