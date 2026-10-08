package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

public interface SellerMpClCatalogRecharterService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 제계약 제출
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//재계약 이력팝업
	public List<Map<String,String>> getSellerMpClCatalogRecharterHistoryPop(Map<String,Object>  param);

	// 재계약 포기
	public String rejectSellerMpClCatalogRecharter(Map<String,String>  formData, List<Object> gridData);
	
}
