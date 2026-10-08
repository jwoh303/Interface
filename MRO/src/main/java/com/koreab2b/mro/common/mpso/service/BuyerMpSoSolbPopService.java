package com.koreab2b.mro.common.mpso.service;

import java.util.Map;

public interface BuyerMpSoSolbPopService {
	// 조회
	public String  getSolbCostCode(Map<String,String>  formData);
	public String  getSolbAccountCode(Map<String,String>  formData);
	public String getSolbPlantCode(Map<String, String> formData);
	
}