package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonCoCoIssueRegPopService {	 

	public String insertCommonCoCoIssueRegPop(Map<String, String> pMap);
	
	// 리스트조회
	public List<Map<String,String>> getCommonCoCoIssueHistHistList(Map<String,Object>  param);
}
