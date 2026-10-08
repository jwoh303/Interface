package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmAdminCatalogSearchService {
	// 카탈로그등록정보
	public List<Map<String,String>> getList(Map<String,String>  formData);

}
