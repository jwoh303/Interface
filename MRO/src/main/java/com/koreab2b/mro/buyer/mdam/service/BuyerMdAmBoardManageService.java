package com.koreab2b.mro.buyer.mdam.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdAmBoardManageService {

	public List<Map<String,String>> getList(Map<String,String>  formData);
	public Map<String,String> getDetailList(Map<String,String>  formData);
	public void updateDetailList(Map<String,String>  formData);
	public void deleteDetailList(Map<String,String>  formData);
	public void insertDetailList(Map<String,String>  formData);
	
}
