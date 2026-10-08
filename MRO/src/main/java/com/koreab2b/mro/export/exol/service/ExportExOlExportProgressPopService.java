package com.koreab2b.mro.export.exol.service;

import java.util.List;
import java.util.Map;

public interface ExportExOlExportProgressPopService {
	// Lot 상세정보 팝업
	public List<Map<String,String>> getLotList(Map<String,Object>  param);
	
	// CI, PL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> getCiData(Map<String,String>  formData);
	
	// CI, PL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> getCiList(Map<String,Object>  param);
	
	// BL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> getBlData(Map<String,String>  formData);
	
	// BL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> getBlList(Map<String,Object>  param);
	
	// CI, PL 상세정보 팝업 하단 그리드 삭제
	public String saveExportExOlExportProgressCiList(Map<String,String>  formData, List<Object> gridData);
}
