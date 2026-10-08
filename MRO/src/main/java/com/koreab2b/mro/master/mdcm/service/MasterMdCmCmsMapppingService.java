package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsMapppingService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// CMS매핑
	public String updateSelectedData(Map<String,String>  formData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 엑셀업로드
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData);

}
