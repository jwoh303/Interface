package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoDelyReturnCowayService {

	/**
	 * 반납품목 조회
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getList(Map<String, String> formData);

	/**
	 * 선택품목반납
	 * 
	 * @param paramList
	 * @return
	 */
	public Map<String, String> setReturnPrIns(List<Map<String, String>> paramList);

	public String getOrderNo(String bUYER, String string);

}
