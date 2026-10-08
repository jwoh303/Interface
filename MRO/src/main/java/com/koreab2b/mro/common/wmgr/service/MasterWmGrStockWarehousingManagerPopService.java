package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGrStockWarehousingManagerPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getPop(Map<String,String>  formData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);

}
