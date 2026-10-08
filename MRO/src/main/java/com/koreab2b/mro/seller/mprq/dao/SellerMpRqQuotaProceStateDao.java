package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpRqQuotaProceStateDao {
	
	/*조회*/
	public List<Map<String,String>> selectList(Map<String,String>  formData);

	// 저장
	public String saveSellerMpRqQuotaProceState(Map<String,String> pMap);
}
