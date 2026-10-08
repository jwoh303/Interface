package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStAgingService {

	/**
	 * 재고 에이징 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getAgingList(Map<String, Object> pMap);
	
	/**
	 * 재고 에이징 상세내역 조회
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getAgingDetail(Map<String, Object> pMap);
	
	/**
	 * 재고 에이징 상품 마스터 정보 조회.
	 * @param pMap
	 * @return
	 */
	public List<Map<String,String>> getAgingItemMaster(Map<String, String> pMap);
}
