package com.koreab2b.mro.buyer.mpds.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpDsOrderManageService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	//부분입고	
	public String updateSelectedDataGrNextMonth(Map<String,String>  formData, List<Object> gridData);
	
	// 입고취소
	public String updateSelectedDataGrCancelReg(Map<String,String>  formData, List<Object> gridData);
	
	// 입고실적등록
	public String updateSelectedDataGrRegBuyer(Map<String,String>  formData, List<Object> gridData);
	
}
