package com.koreab2b.mro.common.wmst.service;

import java.util.List;
import java.util.Map;

public interface MasterWmStAssmblNoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	//상단조회 
	public List<Map<String,String>> getPop(Map<String,Object>  formData);
	
	//조립취소
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//조립완료 
	public String updateSelectedDataCom(Map<String,String>  formData, List<Object> gridData);
}
