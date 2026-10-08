package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoCartExcelUploadDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 장바구니 담기
	public String setCartAddReg(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 업로드
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
