package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClClosInfoDao {

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 리뉴얼 버전 리스트 조회 (검색조건 추가)
	public List<Map<String,String>> selectList_V2(Map<String,Object> param);

	// 마감 대상 내역 조회
	public List<Map<String,String>> selectTargetList_V2(Map<String,Object> param);
	public List<Map<String,String>> selectTargetList_V3(Map<String,Object> param);

	// 탭5 전용 리스트 조회
	public List<Map<String,String>> selectTab5List(Map<String,Object> param);
	public List<Map<String,String>> selectTab5List_v2(Map<String,Object> param);
}
