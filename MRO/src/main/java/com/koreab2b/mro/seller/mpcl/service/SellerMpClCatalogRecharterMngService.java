package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

public interface SellerMpClCatalogRecharterMngService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
}
