package com.koreab2b.mro.seller.mdct.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdCtUserSearchDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	// 리뉴얼용 조회 (페이징 없음)
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);

	// 삭제
	public String updateSelectedData(Map<String,String> formData);
}
