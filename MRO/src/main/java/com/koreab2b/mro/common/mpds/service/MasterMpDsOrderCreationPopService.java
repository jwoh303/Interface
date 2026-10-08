package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface MasterMpDsOrderCreationPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public List<Map<String,String>> moveList(Map<String,Object>  formData);
	// 저장
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData);

}
