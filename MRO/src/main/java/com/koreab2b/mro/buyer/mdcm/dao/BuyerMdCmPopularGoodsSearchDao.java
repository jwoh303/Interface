package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmPopularGoodsSearchDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 저장
	public String saveBuyerMdCmPopularGoods(Map<String,String> formData);
	// 카테고리업데이트
	public String saveBuyerMdCmFolderCode(Map<String,String> formData);
	// 카테고리ICOMUSCA 업데이트
	public String saveBuyerMdCmFolderName(Map<String,String> formData);
	// 삭제조회
	public List<Map<String,String>> selectDeleteList(Map<String,String> formData);
	// 그린상품조회
	public List<Map<String,String>> selectGreenList(Map<String,String> formData);
	// 프로젝트상품조회
	public List<Map<String,String>> selectProjectList(Map<String,String> formData);
}
