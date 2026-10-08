package com.koreab2b.mro.buyer.mpst.service;

import java.util.List;

import java.util.Map;

public interface BuyerMpStWarehouseGiService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
		
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 출고
	public String setSelectedData(Map<String,String>  formData, List<Object> gridData);
}
