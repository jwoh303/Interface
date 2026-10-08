package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqDoosanStockCodeInsPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public String saveDoosanStockCode(Map<String,String>  formData, List<Object> gridData);
}
