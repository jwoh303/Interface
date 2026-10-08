package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClClArApMappingService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 계산서리스트조회
	public List<Map<String,String>> getTaxList(Map<String,Object>  param);
	// 계산서 상계처리 매핑
	public String callProcTaxSkip(Map<String,String> formData);
	// 계산서 수동 상계처리
	public String updateProcTaxSkip(Map<String,String>  formData, List<Object> gridData);
	// 매출 자동매핑
	public String callProcTaxMappingAr(Map<String,String> formData);
	// 매입 자동매핑
	public String callProcTaxMappingAp(Map<String,String> formData);
	// 저장
	public String savetMasterCmClArApMappingList(Map<String,String> formData);
	// 예외저장
	public String saveExceptionMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData);
	// 확정
	public String confirmtMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData);
	// 매핑취소
	public String cancleMappingMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData);
	// 취소
	public String cancleMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData);
}
