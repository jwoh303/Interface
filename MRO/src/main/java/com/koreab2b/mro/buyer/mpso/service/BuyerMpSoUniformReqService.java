package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoUniformReqService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 엑셀업로드
	public String uploadSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 등록
	public String regSelectedData(Map<String,String>  formData, List<Object> gridData);
}
