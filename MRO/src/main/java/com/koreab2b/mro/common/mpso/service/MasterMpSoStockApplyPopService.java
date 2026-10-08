package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoStockApplyPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public List<Map<String,String>> getListDetail(Map<String,Object>  formData);

	//저장
	public String saveSelectedData(Map<String,String>  formData, List<Object> gridData);
}
