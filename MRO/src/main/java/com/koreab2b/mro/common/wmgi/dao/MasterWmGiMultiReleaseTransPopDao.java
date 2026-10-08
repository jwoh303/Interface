package com.koreab2b.mro.common.wmgi.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGiMultiReleaseTransPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// TR다중출고지시
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}