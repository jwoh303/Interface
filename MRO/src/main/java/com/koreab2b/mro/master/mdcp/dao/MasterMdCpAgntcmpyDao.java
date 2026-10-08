package com.koreab2b.mro.master.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpAgntcmpyDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 엑셀리스트 조회
	public List<Map<String,String>> selectExcelList(Map<String,Object> param);
		
	// 신용평가여부 조회
	public String selectCreaditCnt(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

}
