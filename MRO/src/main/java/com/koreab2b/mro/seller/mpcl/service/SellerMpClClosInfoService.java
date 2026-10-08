package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

public interface SellerMpClClosInfoService {

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 리뉴얼 버전 리스트조회 (검색조건 추가)
	public List<Map<String,String>> getList_V2(Map<String,Object>  param);

	// 마감 대상 내역 조회
	public List<Map<String,String>> getTargetList_V2(Map<String,Object>  param);
	public List<Map<String,String>> getTargetList_V3(Map<String,Object>  param);

	// 탭5 전용 리스트 조회
	public List<Map<String,String>> getTab5List(Map<String,Object>  param);
	public List<Map<String,String>> getTab5List_v2(Map<String,Object>  param);
}
