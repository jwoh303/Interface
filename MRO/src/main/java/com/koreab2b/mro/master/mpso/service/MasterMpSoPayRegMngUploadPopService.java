package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoPayRegMngUploadPopService {
	
	// Upload 데이터 조회
	public List<Map<String, String>> getList(Map<String, Object> param);
	
	// PO조회
	public List<Map<String, String>> PoSearch(Map<String, String> param);
	
	// 엑셀 업로드 저장
	public String saveExcelUploadData(Map<String, String> formData, List<Object> gridData);
	
	// 지급이슈 저장
	public String saveUploadList(Map<String, String> formData, List<Object> gridData);
	
	// 삭제
	public String deleteUploadList(Map<String, String> formData, List<Object> gridData);

	
}
