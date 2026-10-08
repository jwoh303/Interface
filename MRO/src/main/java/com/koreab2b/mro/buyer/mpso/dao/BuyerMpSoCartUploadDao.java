package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartUploadDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	
	// 저장
	public String saveExcelUp(Map<String,String>  formData);
	
	// 저장
	public String saveSetCartAddReg(Map<String,String>  formData);
	//삭제
	public String removeSetCartAddDel(Map<String,String>  formData);
}
