package com.koreab2b.mro.common.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClTaxamntAlterApPopService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 조회
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

}
