package com.koreab2b.mro.export.exol.service;

import java.util.List;
import java.util.Map;

public interface ExportExOlExportProgressPoService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// HS CODE 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
