package com.koreab2b.mro.promote.dao;

import java.util.List;
import java.util.Map;

public interface PromoteDao {
	public Map<String,String> getKeyWord();
	
	public List<Map<String,String>> getCatalogItemPlan();
	
	public List<Map<String,String>> getCatalogMainItem();
	
	public List<Map<String,String>> getPromoteCatalogList(Map<String,String>  formData);
	
	public List<Map<String,String>> getCatalogItemRecommand(Map<String,String>  formData);
	
	public List<Map<String,String>> getCategoryListThis(Map<String,String>  formData);
	
	public List<Map<String,String>> getPromoteDetailList(Map<String,String>  formData);
	
	public String saveItemApproval(Map<String,String>  formData);
	
}
