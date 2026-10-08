package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogInfoMultiAlterService {
	
	// 카탈로그 일괄수정 조회
	public List<Map<String,String>> getMasterMdCmCatalogInfoMultiAlter(Map<String,Object>  param);
	// 카탈로그 일괄수정 엑셀 업로드
	public String batchMasterMdCmCatalogInfoMultiAlter(Map<String, String> param,List<Object> gridData);
	// 카탈로그 일괄수정 삭제
	public String delMasterMdCmCatalogInfoMultiAlter(Map<String, String> param,List<Object> gridData);
	// 카탈로그 일괄수정 반영대상
	public List<Map<String,String>> getMasterMdCmCatalogInfoBeforeAfter(Map<String,Object>  param);
	// 카탈로그 일괄수정 품의 상신
	public String requestMasterMdCmCatalogInfoSearchPop(Map<String, String> param,List<Object> gridData);
}
