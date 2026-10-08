package com.koreab2b.mro.common.wmco.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmCoWarehousingDetailPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	
	// 조회
	public List<Map<String,String>> selectDetail(Map<String,Object> formData);
	
	public String updateSelectedData(Map<String, String> formData,List<Object> gridData);
	public String updateSelectedData_v2(Map<String, String> formData,List<Object> gridData);
	
	public String updateSelectedDataIvt(Map<String, String> formData,List<Object> gridData);

}
