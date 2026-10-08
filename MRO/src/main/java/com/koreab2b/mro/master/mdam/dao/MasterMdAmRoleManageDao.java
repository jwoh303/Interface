package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmRoleManageDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	//조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> param);

	// 저장(상세)
	public String updateSelectedDetailData(Map<String,String>  formData, List<Object> gridData);

	// 삭제(상세)
	public String deleteSelectedDetailData(Map<String,String>  formData, List<Object> gridData);

}
