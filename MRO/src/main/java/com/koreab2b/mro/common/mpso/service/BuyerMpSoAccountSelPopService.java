package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoAccountSelPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public List<Map<String,String>> getDeptSelect(Map<String,String>  formData);
	public List<Map<String,String>> getAccountDivideList(Map<String,String>  formData);

}
