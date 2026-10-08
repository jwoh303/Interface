package com.koreab2b.mro.export.exol.dao;

import java.util.List;
import java.util.Map;

public interface ExportExOlExportProgressPopDao {
	// Lot 상세정보 팝업
	public List<Map<String,String>> selectLotList(Map<String,Object> param);
	
	// CI, PL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> selectCiData(Map<String,String> formData);
	
	// CI, PL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> selectCiList(Map<String,Object> param);
	
	// BL 상세정보 팝업 상단 헤더
	public List<Map<String,String>> selectBlData(Map<String,String> formData);
	
	// BL 상세정보 팝업 하단 그리드
	public List<Map<String,String>> selectBlList(Map<String,Object> param);
	
	// CI, PL 상세정보 팝업 하단 그리드 삭제
	public String saveExportExOlExportProgressCiList(Map<String,String>  formData, List<Object> gridData);
}
