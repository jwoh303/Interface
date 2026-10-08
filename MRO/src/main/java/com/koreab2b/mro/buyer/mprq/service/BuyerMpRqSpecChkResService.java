package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqSpecChkResService {
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	/*등록 요청*/
	public String regData(List<Object> gridData, Map<String,String>  formData);

	/*장바구니 담기*/
	public String addData(List<Object> gridData, Map<String,String>  formData);

	/*삭제*/
	public String delData(List<Object> gridData, Map<String,String>  formData);
	
	 
}
