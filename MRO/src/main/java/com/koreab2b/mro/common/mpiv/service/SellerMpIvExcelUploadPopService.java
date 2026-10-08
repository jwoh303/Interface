package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvExcelUploadPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getSellerMpIvExcelUploadPop_v2(Map<String,Object>  formData);
	
	// 엑셀업로드
	public String setExcelUp(Map<String,String>  formData);
	public String setMpIvExcelUp_v2(Map<String,String>  formData, List<Object> gridData);
	
	
	// 엑셀 TMP 삭제
	public String delExcelUp(Map<String,String>  formData);
}
