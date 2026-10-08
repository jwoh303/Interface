package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

public interface CommonCoCoBuyerCategoryChoiceDooPopService {
	public String getCategoryComText(Map<String, String> pMap) ;
	
	public List<Map<String,String>> getBuyerCategorySearch(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getBuyerCategorySearchReqValue(Map<String,String> pMap) ;
	
}
