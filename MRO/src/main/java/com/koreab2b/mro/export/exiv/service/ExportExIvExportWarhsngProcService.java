package com.koreab2b.mro.export.exiv.service;

import java.util.List;
import java.util.Map;

public interface ExportExIvExportWarhsngProcService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 상세입고등록
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData);
	
	// 상세입고등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//납품상세조회
	public List<Map<String,String>> getDetail(Map<String,Object>  formData);
	
	//납품상세조회 품목
	public List<Map<String,String>> getDetailData(Map<String,Object>  formData);
	
	// 상세 리스트조회
	public List<Map<String,String>> getDetailList(Map<String,Object>  param);
	
}
