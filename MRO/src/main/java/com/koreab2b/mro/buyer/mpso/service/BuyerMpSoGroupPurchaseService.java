package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoGroupPurchaseService {

	/**
	 * 공동구매 리스트
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, Object>> getList(Map<String, String> formData);
	/**
	 * 명절선물구매 리스트
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, Object>> getHolidayList(Map<String, String> formData);
	/**
	 * 공동구매 신청
	 * 
	 * @param paramList
	 * @return
	 */
	public Map<String, String> setGroupPurchase(List<Map<String, String>> paramList);
	/**
	 * 판매자등록증 신청리스트
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, Object>> getBuyerMpSoSellerRegList(Map<String, String> formData);
	/**
	 * 판매자등록즈 신청
	 * 
	 * @param paramList
	 * @return
	 */
	public Map<String, String> setBuyerMpSoSellerRegListdo(List<Map<String, String>> paramList);

}
