package com.koreab2b.mro.common.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClTaxamntAlterPopDao {

	// 리스트조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

}
