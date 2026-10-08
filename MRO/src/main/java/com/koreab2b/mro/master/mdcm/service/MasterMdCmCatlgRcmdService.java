package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCatlgRcmdService {
	// 업로드 후 조회
	public List<Map<String,String>> getUploadList(Map<String,Object>  param);

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// BNTRXL 저장
	public String updateUploadData(Map<String,String>  formData, List<Object> gridData);
	
	// 추천
	public String updateData(Map<String,String>  formData, List<Object> gridData);
}
