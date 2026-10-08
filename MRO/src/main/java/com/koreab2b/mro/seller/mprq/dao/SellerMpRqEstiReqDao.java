package com.koreab2b.mro.seller.mprq.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpRqEstiReqDao {
	
	/*조회*/
	public List<Map<String,String>> selectList(Map<String,String>  formData);
	
	/*등록요청*/
	public String updateData(Map<String,String> formData, List<Object> gridData);

	/*견적포기*/
	public String sellerMpRqEstiReqGiveUp(Map<String,String> formData, List<Object> gridData);

}
