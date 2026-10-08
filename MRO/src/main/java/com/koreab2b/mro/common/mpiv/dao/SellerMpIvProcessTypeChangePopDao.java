package com.koreab2b.mro.common.mpiv.dao;

import java.util.Map;

public interface SellerMpIvProcessTypeChangePopDao {

	// 거래유형 변경 요청
	public String saveSellerMpIvProcessTypeChangeReq(Map<String, String> formData);
}
