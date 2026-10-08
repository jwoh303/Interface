package com.koreab2b.mro.buyer.mpds.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpDsAgrchemiPckmtrlService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getListSub(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
