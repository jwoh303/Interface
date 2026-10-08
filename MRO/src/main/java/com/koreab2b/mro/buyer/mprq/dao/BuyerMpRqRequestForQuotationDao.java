package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqRequestForQuotationDao {
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	public Map<String,String> updateSelectedData(Map<String,String> formData, List<Object> gridData);
	public String updateSelectedDataNoPass(Map<String,String> formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataPass(Map<String,String> formData, List<Object> gridData);
	
	public String delReqQuotation(Map<String,String> formData, List<Object> gridData);
	
	public String ngRequest(Map<String,String>  formData);
	public String ngCancel(Map<String,String>  formData);
	public String ngApproval(Map<String,String>  formData);
	public String ngReject(Map<String,String>  formData);
	public String ngReject_v2(Map<String,String>  formData);
	public List<Map<String,String>> ngResultList(Map<String,String>  formData);
	public List<Map<String,String>> ngResultList_v2(Map<String,Object>  formData);
}
