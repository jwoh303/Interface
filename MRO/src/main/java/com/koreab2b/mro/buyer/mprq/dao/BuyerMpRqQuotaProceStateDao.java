package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

import org.springframework.util.MultiValueMap;

public interface BuyerMpRqQuotaProceStateDao {
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
	
	public String deleteSelectedData(Map<String,String> formData, List<Object> gridData);
	
	//엑셀 상세조회
	public List<Map<String,String>> selectDetailList(Map<String,String> formData);

	public List<Map<String, String>> selectList_v2(Map<String, Object> pMap);

	//장바구니 담기 _v2
	public String updateSelectedData_v2(Map<String, String> pMap);

	// 견적요청 조회 _v2
	public List<Map<String, String>> selectList_tab2_v2(Map<String, Object> pMap);

}
