package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;


import java.util.Map;

public interface BuyerMdCmUniformSearchDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
