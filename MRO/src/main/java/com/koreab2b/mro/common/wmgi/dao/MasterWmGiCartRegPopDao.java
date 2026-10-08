package com.koreab2b.mro.common.wmgi.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGiCartRegPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	//장바구니 담기 
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
