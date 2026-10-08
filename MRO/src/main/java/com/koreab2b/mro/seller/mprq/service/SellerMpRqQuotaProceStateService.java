package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

public interface SellerMpRqQuotaProceStateService {
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// 저장
	public String saveSellerMpRqQuotaProceState(Map<String,String>  pMap);
}
