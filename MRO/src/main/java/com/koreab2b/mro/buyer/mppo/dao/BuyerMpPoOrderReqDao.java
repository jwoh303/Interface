package com.koreab2b.mro.buyer.mppo.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoOrderReqDao {

	// 조회
	public List<Map<String,String>> getBuyerMpPoOrderReqList_v2(Map<String,Object> formData);
}
