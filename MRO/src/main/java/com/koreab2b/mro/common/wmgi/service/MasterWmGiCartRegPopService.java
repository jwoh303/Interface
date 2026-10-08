package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGiCartRegPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	//장바구니 담기 
	public String updateSelectedData(Map<String, String> formData  , List<Object> gridData);
}
