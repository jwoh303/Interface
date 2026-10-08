package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoDelyReturnCowayDao {

	public List<Map<String, String>> selectList(Map<String, String> formData);

	public Map<String, String> setReturnPrIns(List<Map<String, String>> pList);

	public String getOrderNo(String buyer, String docType);

}
