package com.koreab2b.mro.export.exbl.service;

import java.util.List;
import java.util.Map;

public interface ExportExBlExportBlProcService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 리스트 상세조회
	public List<Map<String,String>> getDetailData(Map<String,Object>  param);
	
	// B/L 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
