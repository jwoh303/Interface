package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvMkImScheduleRegService {
	/**
	 * 조회
	 * 
	 * @param formData
	 * @return
	 */
	public List<Map<String, String>> getList(Map<String, String> formData);
	
	public List<Map<String, String>> getPopupList(Map<String, String> pMap);
	
	public int saveMkImScheduleReg(Map<String, String> formData);
	
	public int saveMkImScheduleUpdate(Map<String, String> formData);

}
