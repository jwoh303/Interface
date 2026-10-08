package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmPopularGoodsSearchService {
	// 인기상품 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	// 저장
	public String saveBuyerMdCmPopularGoods(Map<String,String>  formData);
	// 카테고리 업데이트
	public String saveBuyerMdCmFolderCode(Map<String,String>  formData);
	// 카테고리 ICOMUSCA 업데이트
	public String saveBuyerMdCmFolderName(Map<String,String>  formData);
	// 삭제단종 조회
	public List<Map<String,String>> getDeleteList(Map<String,String>  formData);	 
	
	// 그린상품 조회
	public List<Map<String,String>> getGreenList(Map<String,String>  formData);
	
	// 프로젝트상품 조회
	public List<Map<String,String>> getProjectList(Map<String,String>  formData);
}
