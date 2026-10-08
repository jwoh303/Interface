package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

public interface MasterMdAmUserManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 조회(상세)
	public List<Map<String,String>> getDetailList(Map<String,Object>  param);

	// 저장(상세)
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제(상세)
	public String delSelectedDetailData(Map<String,String>  formData, List<Object> gridData);
}
