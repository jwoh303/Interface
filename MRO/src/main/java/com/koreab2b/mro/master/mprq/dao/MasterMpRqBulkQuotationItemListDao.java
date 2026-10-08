package com.koreab2b.mro.master.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqBulkQuotationItemListDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 선택삭제
	public String deleteData(Map<String,Object> param);
	
	// 프로젝트 조회 팝업
	public List<Map<String,String>> selectProject(Map<String,Object> param);
	

}
