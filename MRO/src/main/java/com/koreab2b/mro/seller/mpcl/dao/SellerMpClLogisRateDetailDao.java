package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClLogisRateDetailDao {

	// 리스트 조회 (레거시)
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 리스트 조회 (리뉴얼)
	public List<Map<String,String>> selectList_v2(Map<String,Object> param);
	public List<Map<String,String>> selectList_v3(Map<String,Object> param);
}
