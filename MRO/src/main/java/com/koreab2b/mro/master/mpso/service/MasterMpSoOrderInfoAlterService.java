package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoOrderInfoAlterService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	
	
	
	
	
	
	
	
	
	
	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList(Map<String,Object>  param);
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList_v2(Map<String,Object>  param);

	// 저장  ( 일괄)
	public String saveMasterMpSoOrderInfoAlterMultiList(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제 ( 일괄)
	public String delMasterMpSoOrderInfoAlterMultList(Map<String,String>  formData, List<Object> gridData);
	
	 
	
	
	
	

}
