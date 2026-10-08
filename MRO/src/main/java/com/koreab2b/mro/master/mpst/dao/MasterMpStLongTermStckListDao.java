package com.koreab2b.mro.master.mpst.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpStLongTermStckListDao {
	
	// 장기재고 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 장기재고 상세 팝업 조회
	public List<Map<String,String>> selectPopList(Map<String,Object> param);
			
	// 장기재고 상세 리스트 조회
	public List<Map<String,String>> selectDtList(Map<String,Object> param);
	
	// 재고현황 추이 리스트 조회
	public List<Map<String,String>> selectFlowList(Map<String,Object> param);
}
