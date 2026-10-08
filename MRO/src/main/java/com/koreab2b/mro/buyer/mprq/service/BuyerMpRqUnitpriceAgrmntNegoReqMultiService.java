package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqUnitpriceAgrmntNegoReqMultiService {
	// 조회
	public List<Map<String,String>> getListMulti(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerMpRqUnitpriceAgrmntNegoReqMultiList_v2(Map<String,Object>  formData);
	
	// 저장
	public String updateSelectedDataMulti(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntMulti(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public Map<String,String> saveBuyerMpRqUnitpriceAgrmntNonPassMulti(Map<String,String>  formData, List<Object> gridData);
	// 견적종료
	public Map<String,String> saveBuyerMpRqCloseRemarkMulti(Map<String,String>  formData, List<Object> gridData);
}
