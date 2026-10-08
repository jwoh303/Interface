package com.koreab2b.mro.master.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoExportProgressPoDao {
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// HS CODE 등록
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
