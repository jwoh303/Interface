package com.koreab2b.mro.master.mdcd.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCdBuyerCardSearchService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
		
}
