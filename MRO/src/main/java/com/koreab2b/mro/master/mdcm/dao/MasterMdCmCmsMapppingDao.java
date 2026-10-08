package com.koreab2b.mro.master.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCmCmsMapppingDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// CMS매핑
	public String updateSelectedData(Map<String, String> formData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 파일업로드
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData);

	

}
