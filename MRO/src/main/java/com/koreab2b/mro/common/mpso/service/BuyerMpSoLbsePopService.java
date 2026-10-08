package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

public interface BuyerMpSoLbsePopService {
	// 조회
	public String  getLbseCostCode(Map<String,String>  formData);
	public String  getLbseAccountCode(Map<String,String>  formData);
}