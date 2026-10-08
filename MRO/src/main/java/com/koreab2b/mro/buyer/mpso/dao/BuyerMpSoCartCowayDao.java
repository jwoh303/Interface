package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartCowayDao {

	// 조회
	public List<Map<String, String>> selectList(Map<String, String> formData);

	public List<Map<String, String>> selectClcsList(Map<String, String> formData);

	public List<Map<String, String>> selectBuyerUserCowayBudgetOrderListPop(Map<String, String> formData);

	public List<Map<String, String>> selectBuyerUserCowayBudgetAccountListPop(Map<String, String> formData);

	public List<Map<String, String>> selectBuyerCowayUserBudgetAccountListPop(Map<String, String> formData);

	public List<Map<String, String>> selectCowayBuyerAdminBdgtTempCheck(Map<String, String> formData);

	public String getK005List(Map<String, String> formData);

	public String getBuyerCartQty(Map<String, String> formData);

	public String updateAttatch(Map<String, String> formData);

	public String setDeleteTempCart(Map<String, String> formData);
}
