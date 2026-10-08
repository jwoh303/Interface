package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmCategoryGoodsSearchDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 저장
	public String updateSelectedData(Map<String,String> formData, List<Object> gridData);
	// 카테고리 조회
	public List<Map<String, String>>  getCategoriList(Map<String,String>  pMap) ;
	// 펀치아웃카테고리 조회
	public List<Map<String, String>>  getCategoryPCOList(Map<String,String>  pMap) ;
	// 카테고리 조회
	public List<Map<String, String>>  getStdCategoriList(Map<String,String>  pMap) ;
}
