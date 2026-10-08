package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoUniformGrHistoryPopService {
	// 조회
	public List<Map<String,String>> getHdList(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getDtList(Map<String,String>  formData);
}
