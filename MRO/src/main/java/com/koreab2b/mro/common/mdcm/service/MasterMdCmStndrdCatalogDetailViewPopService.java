package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmStndrdCatalogDetailViewPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 상품상세속성
	public List<Map<String,String>> getCmsCatalogDispPopAttr(Map<String,String>  formData);
	
	// 이미지
	public List<Map<String,String>> getCmsCatalogDispPopImg(Map<String,String>  formData);
	
	// 저장
	public String updateSelectedData (Map<String,String> formData);
}
