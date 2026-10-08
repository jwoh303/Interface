package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvMkImScheduleRegDao {

	/**
	 * 조회
	 * 
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectList(Map<String, String> pMap);

	/**
	 * 팝업 조회 
	 * 
	 * @param pMap
	 * @return
	 */
	public List<Map<String, String>> selectPopupList(Map<String, String> pMap);

	/**
	 * merge(i/u)
	 * @param list
	 * @return
	 */
	public int saveMkImScheduleReg(List<Map<String, String>> list);

	int saveMkImScheduleUpdate(Map<String, String> formData);

}
