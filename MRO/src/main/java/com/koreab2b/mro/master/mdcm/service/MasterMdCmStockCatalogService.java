package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmStockCatalogService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	public String getBycaComorgSelect(Map<String, Object> param);
	
}
