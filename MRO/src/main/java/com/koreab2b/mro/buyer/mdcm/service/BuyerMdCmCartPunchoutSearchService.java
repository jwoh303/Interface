package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmCartPunchoutSearchService {
	// 나의상품조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 저장
	public String saveBuyerMdCmCartQtyPunchOut(Map<String,String>  formData);	
	// 장바구니삭제
	public String deleteBuyerMdCmCartListPunchOut(Map<String,String>  formData);
}
