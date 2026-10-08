package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartCowayService {
	// 조회
	public List<Map<String, String>> getList(Map<String, String> formData);

	public List<Map<String, String>> getClcsList(Map<String, String> formData);

	public List<Map<String, String>> getBuyerUserCowayBudgetOrderListPop(Map<String, String> formData);

	public List<Map<String, String>> getBuyerUserCowayBudgetAccountListPop(Map<String, String> formData);

	public List<Map<String, String>> getBuyerCowayUserBudgetAccountListPop(Map<String, String> formData);

	public String getK005List(Map<String, String> formData);

	public String getBuyerCartQty(Map<String, String> formData);

	public String updateAttatch(Map<String, String> formData);

	public List<Map<String, String>> cowayBuyerAdminBdgtTempCheck(Map<String, String> formData);

	public String setDeleteTempCart(Map<String, String> formData);
}
