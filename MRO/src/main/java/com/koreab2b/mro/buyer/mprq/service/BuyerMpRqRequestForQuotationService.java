package com.koreab2b.mro.buyer.mprq.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqRequestForQuotationService {
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	public Map<String,String> updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String updateSelectedDataNoPass(Map<String,String>  formData, List<Object> gridData);
	public Map<String,String> updateSelectedDataPass(Map<String,String>  formData, List<Object> gridData);
	
	public String delReqQuotation(Map<String,String>  formData, List<Object> gridData);
}
