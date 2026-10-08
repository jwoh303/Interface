package com.koreab2b.mro.master.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationItemListService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 프로젝트 조회
	public List<Map<String,String>> getProject(Map<String, Object>  pMap);
	
	// 선택 삭제
	public String deleteData(Map<String,Object>  param);
}
