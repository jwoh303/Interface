package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmAdminCatalogSearchDao {

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData);

}
