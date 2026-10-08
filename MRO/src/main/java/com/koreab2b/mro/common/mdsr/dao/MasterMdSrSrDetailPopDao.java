package com.koreab2b.mro.common.mdsr.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrDetailPopDao {
	// 조회
	public List<Map<String,String>> getMasterMdSrSrDetailPop(Map<String,Object> formData);
	
	// 저장
	public String saveMasterMdSrSrDetailPop(Map<String,String>  formData);
	
	// 결재 결과 페이지
	public List<Map<String,String>> srResultList(Map<String,String> formData);
	
	// 엑셀조회
	public List<Map<String,String>> getExcelMasterPoGrList(Map<String,Object> formData);
	// 엑셀조회
	public List<Map<String,String>> getExcelMasterReList(Map<String,Object> formData);
}
