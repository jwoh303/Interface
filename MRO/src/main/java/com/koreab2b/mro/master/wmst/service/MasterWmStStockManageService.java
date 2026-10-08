package com.koreab2b.mro.master.wmst.service;

import java.util.List;
import java.util.Map;

public interface MasterWmStStockManageService {
	
	// 코드 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 코드 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 코드 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);

}
