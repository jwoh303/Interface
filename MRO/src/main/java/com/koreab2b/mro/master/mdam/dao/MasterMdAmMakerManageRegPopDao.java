package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmMakerManageRegPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	/*등록*/
	public String updateSelectedData(Map<String,String>  formData);
	
	/*등록*/
	public String insertSelectedData(Map<String,String>  formData);
	
	/*제조사 등록*/
	public String insertSelectedMgData(Map<String,String>  formData);
	
}
