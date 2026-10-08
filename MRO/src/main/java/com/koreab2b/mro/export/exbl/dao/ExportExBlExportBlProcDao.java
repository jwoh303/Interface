package com.koreab2b.mro.export.exbl.dao;

import java.util.List;
import java.util.Map;

public interface ExportExBlExportBlProcDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 리스트 상세 조회
	public List<Map<String,String>> selectDetailList(Map<String,Object> param);
	
	// B/L 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
