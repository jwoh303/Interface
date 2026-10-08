package com.koreab2b.mro.common.wmco.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmCoMbrcmpyPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 조회
	public List<Map<String,String>> selectIKList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectCountList(Map<String,Object> formData);
	
	public List<Map<String,String>> selectSingleList(Map<String,Object> formData);

	// 일괄출고지시 고객사 조회
	public List<Map<String,String>> selectBpIKList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectNewIKList(Map<String,Object> formData);
}
