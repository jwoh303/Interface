package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClSalesLogisTaxSumCreationService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	public List<Map<String,String>> getList_v2(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	// 저장
	public String saveMasterCmClSalesLogisNotClose(Map<String,String>  formData, List<Object> gridData);
	public String saveMasterCmClSalesLogisNotClose_v2(Map<String,String>  formData, List<Object> gridData);

}
