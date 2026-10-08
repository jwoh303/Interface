package com.koreab2b.mro.master.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfGrCreateDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 실행
	public String executeDataList(Map<String,String>  formData, List<Object> gridData);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	//엑셀 업로드
	public String updateSelectedDataExcelCheck(Map<String,String>  formData, List<Object> gridData);
	
}
