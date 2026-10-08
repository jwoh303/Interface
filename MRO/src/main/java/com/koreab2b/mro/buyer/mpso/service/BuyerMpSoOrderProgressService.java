package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoOrderProgressService {
	// 조회
	public List<Map<String, String>> getList(Map<String, String> formData);
	public List<Map<String, String>> getBuyerMpSoOrderProgressList_v2(Map<String, Object> formData);

	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);

	/**
	 * 코웨이 품목신청 반납내역
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getBuyerMpSoClcsOrderProgressList(Map<String, String> formData);

	/**
	 * 코웨이 공동구매 신청내역
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getBuyerMpSoGroupPurchaseOrderProgressList(Map<String, String> formData);
	/**
	 * 저장
	 * 
	 * @param formData
	 * @return
	 */
	public String delBuyerMpsoCowayCart(Map<String, String> formData);
	/**
	 * 판매자인증신청리스트
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getBuyerMpSoSellerRegProgressList(Map<String, String> formData);
	/**
	 * 판매자증 대상자 리스트.
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getBuyerMpSoSellerInfoPop(Map<String, String> formData);
	/**
	 * 판매자증저장
	 * 
	 * @param formData
	 * @return
	 */
	public String saveBuyerMpSoSellerRegProgressList(Map<String, String> formData);
	
	public String saveBuyerPrCancel(Map<String, String> formData);
}
