package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartExcelUploadService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 장바구니 담기
	public String setCartAddReg(Map<String,String>  formData, List<Object> gridData);
	
	//삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 업로드
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
