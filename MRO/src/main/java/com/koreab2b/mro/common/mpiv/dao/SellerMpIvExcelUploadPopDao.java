package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvExcelUploadPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> getSellerMpIvExcelUploadPop_v2(Map<String,Object> formData);
	
	// 엑셀 업로드
	public String saveExcelUp(Map<String,String>  formData);
	public String setMpIvExcelUp_v2(Map<String,String>  formData, List<Object> gridData);
	
	// 엑셀 TMP 테이블 삭제
	public String delExcelUp(Map<String,String>  formData);
}
