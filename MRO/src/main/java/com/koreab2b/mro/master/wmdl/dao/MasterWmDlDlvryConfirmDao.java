package com.koreab2b.mro.master.wmdl.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmDlDlvryConfirmDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 택배사저장
	public String updateSelectedDataCenter(Map<String,String>  formData, List<Object> gridData);
	
	public List<Map<String,String>> selectPopList(Map<String,String> param);

}
