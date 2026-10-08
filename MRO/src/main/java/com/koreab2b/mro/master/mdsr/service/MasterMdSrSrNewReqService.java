package com.koreab2b.mro.master.mdsr.service;

import java.util.Map;

public interface MasterMdSrSrNewReqService {
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData);
	
	// 품의상신 DOCU_NO 채번
	public Map<String,String> approvalSelectedData(Map<String,String>  formData);

}
