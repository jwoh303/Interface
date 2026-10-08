package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqCatalogRegYnPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);

}
