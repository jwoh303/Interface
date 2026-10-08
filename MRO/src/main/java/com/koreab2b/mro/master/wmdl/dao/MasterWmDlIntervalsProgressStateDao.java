package com.koreab2b.mro.master.wmdl.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmDlIntervalsProgressStateDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);


	// 저장
	public String updateSelectedPopData(Map<String,String>  formData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

	public List<Map<String,String>> getPopCnt(Map<String,String> param);
}
