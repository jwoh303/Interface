package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClPurchaseTaxsheetAgntcmpySumCreationDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	public List<Map<String,String>> selectList_v2(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	// 삭제
//	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

}
