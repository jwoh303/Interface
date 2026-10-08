package com.koreab2b.mro.common.wmgr.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGrWarehousingPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 조회
	public List<Map<String,String>> getPop(Map<String,Object>  formData);
	public List<Map<String,String>> getPop_v2(Map<String,Object>  formData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData);

}
