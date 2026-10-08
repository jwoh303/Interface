package com.koreab2b.mro.master.mdsr.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrNewReqDao {
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData);
	
	// 품의상신 DOCU_NO 채번
	public Map<String,String> approvalSelectedData(Map<String,String>  formData);
	
	public String srRequest(Map<String,String>  formData);
	public String srCancel(Map<String,String>  formData);
	public String srApproval(Map<String,String>  formData);
	public String srDataApproval(Map<String,String>  formData);
	public String srReject(Map<String,String>  formData);
	public List<Map<String,String>> srResultList(Map<String,String>  formData);
}

