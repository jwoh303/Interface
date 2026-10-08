package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqSpecChkResDao {
	
	/*조회*/
	public List<Map<String,String>> selectList(Map<String,String>  formData);
	
	/*등록요청*/
	public String updateData(List<Object> gridData, Map<String, String> formData);

	/*장바구니 담기*/
	public String insertData(List<Object> gridData, Map<String, String> formData);

	/*삭제*/
	public String deleteData(List<Object> gridData, Map<String, String> formData);

}
