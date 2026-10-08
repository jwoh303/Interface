package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

public interface BuyerMpSohahomePopService {
	// 조회
	public String  gethahomeCostCode(Map<String,String>  formData);
	public String  gethahomeAccountCode(Map<String,String>  formData);
}