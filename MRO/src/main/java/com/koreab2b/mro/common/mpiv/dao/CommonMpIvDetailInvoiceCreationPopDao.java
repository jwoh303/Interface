package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvDetailInvoiceCreationPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 송장등록
	public Map<String, String> saveCommonMpIvDetailInvoiceCreationPop(Map<String, String> pMap);

}
