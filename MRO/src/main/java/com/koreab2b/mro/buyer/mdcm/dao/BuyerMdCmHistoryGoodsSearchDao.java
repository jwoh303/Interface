package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmHistoryGoodsSearchDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectBuyerMdCmHistoryGoodsSearchList_v2(Map<String,String> formData);
	
	// 이력상품검색에서 삭제
	public String deleteItem(Map<String, String> formData);
	 
}
