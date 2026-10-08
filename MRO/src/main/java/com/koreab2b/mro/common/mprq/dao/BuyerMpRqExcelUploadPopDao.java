package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqExcelUploadPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);
	// 저장
	public String saveExcelUp(Map<String,String>  formData);
	public String saveExcelUp_v2(Map<String,String>  formData);
}
