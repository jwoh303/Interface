package com.koreab2b.mro.export.exol.service;

import java.util.List;
import java.util.Map;

public interface ExportExOlExportProgressService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장, 납품완료
	public String updateSelectedHdData(Map<String,String>  formData, List<Object> gridData);
	
	// CI, PL 삭제
	public String updateSelectedCiData(Map<String,String>  formData, List<Object> gridData);
	
	// BL 삭제
	public String updateSelectedBlData(Map<String,String>  formData, List<Object> gridData);
	
}
