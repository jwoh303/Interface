package com.koreab2b.mro.buyer.mdam.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmGoodsLineStateDao {

	// 조회조건 - userList 조회
	public List<Map<String,String>> selectUserList(Map<String,String> formData);
	
	public List<Map<String,String>> selectList(Map<String,String> formData);
}
