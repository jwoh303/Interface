package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClLogisRateMngUploadService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 업로드 저장
	public String saveExcelUploadData(Map<String, String> formData, List<Object> gridData);
	
	// 저장
	public String saveUploadList(Map<String, String> formData, List<Object> gridData);


}
