package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

public interface SellerMdCtUserSearchService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// 리뉴얼용 조회 (페이징 없음)
	public List<Map<String,String>> getList_v2(Map<String,String>  formData);

	// 삭제
	public String updateSelectedData(Map<String,String>  formData);
}
