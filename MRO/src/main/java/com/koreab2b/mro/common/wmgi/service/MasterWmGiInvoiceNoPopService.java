package com.koreab2b.mro.common.wmgi.service;

import java.util.List;
import java.util.Map;

public interface MasterWmGiInvoiceNoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	public List<Map<String,String>> getPop(Map<String,String>  formData);
	
	public String getDoosan(Map<String,String>  formData);
	
	public List<Map<String,String>> getListDelevery(Map<String,Object>  formData);
	
	public String updateSelectedData(Map<String, String> formData  , List<Object> gridData);
	
	public String updateSelectedDataDelevery(Map<String, String> formData  , List<Object> gridData);
}
