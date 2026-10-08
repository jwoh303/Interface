package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoGroupPurchaseDao {

	public List<Map<String, Object>> selectList(Map<String, String> formData);
	
	public List<Map<String, Object>> selectHolidayList(Map<String, String> formData);

	public Map<String, String> setGroupPurchase(List<Map<String, String>> pList);
	
	public List<Map<String, Object>> selectMpSoSellerRegList(Map<String, String> formData);
	
	public Map<String, String> setBuyerMpSoSellerRegListdo(List<Map<String, String>> pList);

}
