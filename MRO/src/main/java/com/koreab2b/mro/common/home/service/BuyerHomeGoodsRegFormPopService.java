package com.koreab2b.mro.common.home.service;

import java.util.List;
import java.util.Map;

public interface BuyerHomeGoodsRegFormPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
		
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
