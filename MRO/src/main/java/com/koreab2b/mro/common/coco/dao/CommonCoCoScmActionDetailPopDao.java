package com.koreab2b.mro.common.coco.dao;

import java.util.Map;

public interface CommonCoCoScmActionDetailPopDao {	 
	
	public Map<String,String> getScmList(Map<String,String> _pMap);
	
	public String updateCommonCoCoScmActionDetailPop(Map<String,String> _pMap);
}
