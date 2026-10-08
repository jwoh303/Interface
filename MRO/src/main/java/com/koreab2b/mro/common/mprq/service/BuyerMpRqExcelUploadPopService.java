package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqExcelUploadPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getList_v2(Map<String,String>  formData);
	// 저장
	public String setExcelUp(Map<String,String>  formData);
	public String setExcelUp_v2(Map<String,String>  formData);
}
