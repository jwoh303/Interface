package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonCoCoBuyerCategoryChoiceTreePopDao {
	public String getCategoryComText(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getCategoryTreeRootSelect(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getCategoryTreeChildSelect(Map<String,String> pMap) ;
}
