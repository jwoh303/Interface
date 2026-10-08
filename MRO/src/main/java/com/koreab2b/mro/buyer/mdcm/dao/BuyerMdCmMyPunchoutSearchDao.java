package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmMyPunchoutSearchDao {

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData);

	// 나의상품삭제
	public int removeBuyerMdCmMyPunchOutLisList(Map<String,String>  formData);
	
	// 엑셀다운로드
	public List<Map<String,String>> getExcelList(Map<String,String> formData);

}
