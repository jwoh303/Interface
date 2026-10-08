package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClCatalogRecharterDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	//재계약 제출
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//재계약 이력팝업
	public List<Map<String,String>> getSellerMpClCatalogRecharterHistoryPop(Map<String,Object> param);
	
	//재계약 포기
	public String rejectSellerMpClCatalogRecharter(Map<String,String>  formData, List<Object> gridData);	
	
}
