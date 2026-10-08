package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpStRecinpayStateDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
}
