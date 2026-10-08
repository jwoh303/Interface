package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatalogRegProgressService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 등록 요청
	public String updateReSourcingData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 소싱변경 업로드
	public String batchSourcingData(Map<String,String>  formData, List<Object> gridData);
	
	// 판가변경 업로드
	public String batchUnitPriceData(Map<String,String>  formData, List<Object> gridData);
	
	// 카탈로그 등록 차수 팝업 조회
	public List<Map<String,String>> getMasterMdCmCatalogRegRevisionList(Map<String,Object>  param);
	
	// 소싱제출, 판가제출 품의 상신
	public Map<String,String> updateData(Map<String,String>  formData, List<Object> gridData);
}