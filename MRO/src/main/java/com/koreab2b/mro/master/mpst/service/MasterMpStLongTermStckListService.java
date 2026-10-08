package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStLongTermStckListService {
	
	// 장기재고 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
		
	// 장기재고 상세 팝업 조회
	public List<Map<String,String>> getPopList(Map<String,Object>  param);
			
	// 장기재고 상세 리스트조회
	public List<Map<String,String>> getDtList(Map<String,Object>  param);
	
	// 재고현황 추이 리스트조회
	public List<Map<String,String>> getFlowList(Map<String,Object>  param);
}
