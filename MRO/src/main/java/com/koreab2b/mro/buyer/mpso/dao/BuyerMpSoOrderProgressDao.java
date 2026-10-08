package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoOrderProgressDao {

	// 조회
	public List<Map<String, String>> selectList(Map<String, String> formData);
	public List<Map<String, String>> getBuyerMpSoOrderProgressList_v2(Map<String, Object> formData);
	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);

	public List<Map<String, String>> getBuyerMpSoClcsOrderProgressList(Map<String, String> formData);

	public List<Map<String, String>> getBuyerMpSoGroupPurchaseOrderProgressList(Map<String, String> formData);
	// 저장
	public String delBuyerMpsoCowayCart(Map<String,String>  formData);
	//조회	
	public List<Map<String, String>> getBuyerMpSoSellerRegProgressList(Map<String, String> formData);
	//조회
	public List<Map<String, String>> getBuyerMpSoSellerInfoPop(Map<String, String> formData);
	// 저장
	public String saveBuyerMpSoSellerRegProgressList(Map<String,String>  formData);
	// 요청취소
	public String saveBuyerPrCancel(Map<String,String>  formData);
}
