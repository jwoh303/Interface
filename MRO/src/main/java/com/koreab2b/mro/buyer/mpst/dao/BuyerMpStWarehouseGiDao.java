package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpStWarehouseGiDao {

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 출고
	public String setSelectedData(Map<String,String>  formData, List<Object> gridData);
}
