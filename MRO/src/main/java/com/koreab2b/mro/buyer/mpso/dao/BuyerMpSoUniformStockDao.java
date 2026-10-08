package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoUniformStockDao {
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
}
