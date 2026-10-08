package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpStWarehouseStockService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

}
