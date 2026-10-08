package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmHistoryGoodsSearchService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> selectBuyerMdCmHistoryGoodsSearchList_v2(Map<String,String>  formData);

	// 이력상품검색에서 삭제
	public String removebuyerMdCmHistoryGoodsItem(Map<String, String> pMap);
	 
}
