package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartUploadService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	

	// 저장
	public String setExcelUp(Map<String,String>  formData);
	
	// 저장
	public String setCartAddReg(Map<String,String>  formData);
	//삭제
	public String setCartAddDel(Map<String,String>  formData);
}
