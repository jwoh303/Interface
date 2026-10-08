package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmMyGoodsSearchService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> selectBuyerMdCmMyGoodsSearchList_v2(Map<String,String>  formData);
	// 내견적조회	
	public List<Map<String,String>> getRqdtList(Map<String,String>  formData);
	// 나의상품삭제
	public int removeBuyerMdCmMyGoodsLisList(Map<String,String>  formData);
	// 나의상품분류저장
	public int saveBuyerMdCmMyGroupLisList(Map<String,String>  formData);
	
	public List<Map<String,String>> getMyCatalgList(Map<String,String>  formData);
}
