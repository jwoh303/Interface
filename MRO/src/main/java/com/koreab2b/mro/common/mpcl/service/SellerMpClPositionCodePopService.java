package com.koreab2b.mro.common.mpcl.service;

import java.util.Map;

public interface SellerMpClPositionCodePopService {
	
	// 조회
	public Map<String,String> getList(Map<String,String>  formData);

	// 저장
	public String insertSelectedData(Map<String,String>  formData);
	
	// 수정
	public String updateSelectedData(Map<String,String>  formData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData);
	
}
