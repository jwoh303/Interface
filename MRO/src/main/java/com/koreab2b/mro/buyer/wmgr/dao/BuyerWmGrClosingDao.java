package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrClosingDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectList_v2(Map<String,Object> formData);

	// [v2] AR 요약 목록
	public List<Map<String,String>> selectArSummaryList(Map<String,String> formData);

	// [v2] AR 상세 내역 (팝업)
	public List<Map<String,String>> selectArDetailList(Map<String,String> formData);

	// [v2] AR 헤더 정보 (팝업 상단)
	public Map<String,String> selectArHeaderInfo(Map<String,String> formData);

}
