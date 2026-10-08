package com.koreab2b.mro.common.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGrWarehousingPopDao {

	
	// 조회
	public List<Map<String,String>> selectPop(Map<String,Object> formData);
	public List<Map<String,String>> selectPop_v2(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	//저장
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData);

}
