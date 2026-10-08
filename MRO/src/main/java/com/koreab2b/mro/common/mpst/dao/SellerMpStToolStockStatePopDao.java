package com.koreab2b.mro.common.mpst.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpStToolStockStatePopDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

}
