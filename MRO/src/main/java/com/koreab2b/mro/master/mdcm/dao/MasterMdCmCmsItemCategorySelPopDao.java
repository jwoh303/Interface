package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsItemCategorySelPopDao {

	// 카테고리 드릴다운/초기 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 카테고리 검색 조회
	public List<Map<String,String>> selectSearchList(Map<String,String> formData);
	// 상세분류 속성 조회 (STUB)
	public List<Map<String,String>> selectAttrList(Map<String,String> formData);
	// 상세분류 정보 단건 조회 (경로/명/카테고리(SG))
	public Map<String,String> selectCategoryInfo(Map<String,String> formData);

}
