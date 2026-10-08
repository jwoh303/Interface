package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoExportProgressPoService {
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// HS CODE 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
