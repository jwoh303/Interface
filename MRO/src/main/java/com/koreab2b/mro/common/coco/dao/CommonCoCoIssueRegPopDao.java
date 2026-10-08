package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonCoCoIssueRegPopDao {	 
	
	public String insertCommonCoCoIssueRegPop(Map<String,String> _pMap);

	// 리스트 조회
	public List<Map<String,String>> getCommonCoCoIssueHistHistList(Map<String,Object> param);
}
