package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrClosingService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getList_v2(Map<String,Object>  formData);

	// [v2] AR 요약 목록
	public List<Map<String,String>> getArSummaryList(Map<String,String> formData);

	// [v2] AR 상세 내역 (팝업)
	public List<Map<String,String>> getArDetailList(Map<String,String> formData);

	// [v2] AR 헤더 정보 (팝업 상단)
	public Map<String,String> getArHeaderInfo(Map<String,String> formData);

}
