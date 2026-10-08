package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpsoCowayReturnService {

	/**
	 * 반납기간 정보 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> getCowayReturnPeriod(Map<String, String> pMap);
	
	/**
	 * 반납기간 정보 저장
	 * @param pMap
	 * @return
	 */
	public String setBuyerCowayReturnPeriodPop(Map<String, String> pMap);
}
