package com.koreab2b.mro.buyer.mppo.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoOrderReqRejectDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData); 
}
