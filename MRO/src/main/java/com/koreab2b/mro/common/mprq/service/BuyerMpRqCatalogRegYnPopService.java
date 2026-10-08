package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqCatalogRegYnPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getList_v2(Map<String,String>  formData);

}
