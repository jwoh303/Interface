package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonCoCoBuyerSpecialCategoryChoicePopDao {
	
	public List<Map<String,String>> getSpecialStdCategLevel1(Map<String,String>  pMap);
	
	public List<Map<String,String>> getBuyerSpecialCategorySearch(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getBuyerSpecialCategorySearchReqValue(Map<String,String> pMap) ;
	
}

