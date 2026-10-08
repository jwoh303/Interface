package com.koreab2b.mro.common.wmco.service;

import java.util.List;
import java.util.Map;

public interface MasterWmCoMbrcmpyPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	// 조회
	public List<Map<String,String>> getIKList(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getCountList(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getSingleList(Map<String,Object>  formData);
	
	// 일괄출고지시 고객사 조회
	public List<Map<String,String>> getBpIKList(Map<String,Object>  formData);

	// 조회
	public List<Map<String,String>> getNewIKList(Map<String,Object>  formData);
}
