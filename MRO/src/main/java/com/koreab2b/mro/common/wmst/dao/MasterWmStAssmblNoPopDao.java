package com.koreab2b.mro.common.wmst.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmStAssmblNoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 상단조회
	public List<Map<String,String>> selectPopList(Map<String,Object> formData);
	
	//조립취소
	public String updateSelectedData(Map<String,String> formData,List<Object> gridData);
	
	//조립완료
	public String updateSelectedDataCom(Map<String,String> formData,List<Object> gridData);
}
