package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoUniformReqDao {
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 파일업로드
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 등록
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData);
}
