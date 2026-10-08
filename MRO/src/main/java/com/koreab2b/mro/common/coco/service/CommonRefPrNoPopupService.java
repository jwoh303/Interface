package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonRefPrNoPopupService {	 
	public List<Map<String,String>> buyerRefPrNoPopList_v2(Map<String, Object> formData);
	
	public String  getCostCode(Map<String,String>  formData);
	public String  getAccountCode(Map<String,String>  formData);
	public String getPlantCode(Map<String, String> formData);
	
	public String  getDeptName(Map<String,String>  formData);
	public String getAccountName(Map<String, String> formData);
	
	public String getCod2Text1(Map<String, String> formData);
	public List<Map<String,String>> getCod2CodeText1(Map<String, String> formData);
}
