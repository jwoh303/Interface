package com.koreab2b.mro.common.mpcl.dao;

import java.util.Map;

public interface SellerMpClDlvryCarPopDao {

	// 조회
	public Map<String,String> selectList(Map<String,String> formData);
	
	// 저장
	public String insertSelectedData(Map<String,String> formData);
	
	// 수정
	public String updateSelectedData(Map<String,String> formData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String> formData);

}
