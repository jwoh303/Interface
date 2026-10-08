package com.koreab2b.mro.master.mpst.service;

import java.util.List;
import java.util.Map;

public interface MasterMpStAgingGrService {
	// 재고에이징(입고) 조회
	public List<Map<String,String>> getAgingGrList(Map<String, Object> pMap);
	
	// 장기재고 증감현황 조회
	public List<Map<String,String>> getLongTermStckIncrList(Map<String, Object> pMap);
	
	// 재고에이징(입고) 상세 조회
	public List<Map<String,String>> getAgingGrDtList(Map<String, Object> pMap);
}
