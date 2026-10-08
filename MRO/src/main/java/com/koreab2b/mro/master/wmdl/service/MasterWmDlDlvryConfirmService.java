package com.koreab2b.mro.master.wmdl.service;

import java.util.List;
import java.util.Map;

public interface MasterWmDlDlvryConfirmService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 택배사저장
	public String updateSelectedDataCenter(Map<String,String>  formData, List<Object> gridData);
	
	public List<Map<String,String>> getPop(Map<String, String> pMap);

}
