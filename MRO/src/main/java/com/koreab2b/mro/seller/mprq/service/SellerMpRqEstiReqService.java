package com.koreab2b.mro.seller.mprq.service;

import java.util.List;
import java.util.Map;

public interface SellerMpRqEstiReqService {
	
	/*조회*/
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	/*등록 요청*/
	public String updateData(Map<String,String>  formData, List<Object> gridData);

	/*포기*/
	public String sellerMpRqEstiReqGiveUp(Map<String,String> formData, List<Object> gridData);
	
	 
}
