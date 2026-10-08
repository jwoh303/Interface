package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoNewDoctorBatchRegService {

	/**
	 * 신규닥터 일괄 주문 상품 리스트
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, Object>> getList(Map<String, String> formData);

	/**
	 * 신규닥터 일괄주문
	 * 
	 * @param paramList
	 * @return
	 */
	public Map<String, String> setNewDoctorCreatePo(List<Map<String, String>> paramList);

}
