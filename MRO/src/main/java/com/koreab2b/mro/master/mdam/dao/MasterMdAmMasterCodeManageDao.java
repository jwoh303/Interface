package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmMasterCodeManageDao {
	
	// 코드 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	public List<Map<String,String>> selectList_v2(Map<String,Object> param);

	// 코드 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 코드 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

}
