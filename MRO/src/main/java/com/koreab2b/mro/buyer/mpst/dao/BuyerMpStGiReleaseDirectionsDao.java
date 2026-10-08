package com.koreab2b.mro.buyer.mpst.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpStGiReleaseDirectionsDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 출고
	public String updateSelectedGiData(Map<String,String> formData, List<Object> gridData);
	
	// 출고취소
	public String updateSelectedGiCancelData(Map<String,String> formData, List<Object> gridData);
	
	// 확정
	public String updateSelectedGiCompleteData(Map<String,String> formData, List<Object> gridData);
}
