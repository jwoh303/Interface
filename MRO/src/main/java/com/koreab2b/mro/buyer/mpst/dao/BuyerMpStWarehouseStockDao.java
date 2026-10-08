package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpStWarehouseStockDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

}
