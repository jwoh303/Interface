package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface CommonPopupMpsoInfoDao {	 
	public Map<String,String> poDetailPopHd(Map<String,String>  pMap);
	public List<Map<String,String>> poDetailPopDt(Map<String,String>  pMap);

	// 특수로직 (발주서인쇄) 조회
	public List<Map<String, String>> getSpecialLogicInfo(Map<String,String> formData);
		
	public Map<String,String> poDetailHistPopHd(Map<String,String>  pMap);
	public List<Map<String,String>> poDetailHistPopDt(Map<String,String>  pMap);

}
