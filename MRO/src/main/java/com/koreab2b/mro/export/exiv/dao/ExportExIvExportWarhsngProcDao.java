package com.koreab2b.mro.export.exiv.dao;

import java.util.List;
import java.util.Map;

public interface ExportExIvExportWarhsngProcDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 상세입고등록
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData);
	
	// 상세입고등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 납품번호 상세조회
	public List<Map<String,String>> selectDetail(Map<String,Object> formData);
	
	// 납품번호 상세조회 품목
	public List<Map<String,String>> selectDetailData(Map<String,Object> formData);

	// 상세 리스트 조회
	public List<Map<String,String>> selectDetailList(Map<String,Object> param);
}
