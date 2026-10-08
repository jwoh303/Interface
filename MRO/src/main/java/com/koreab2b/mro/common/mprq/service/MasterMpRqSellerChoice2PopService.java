package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

public interface MasterMpRqSellerChoice2PopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	public List<Map<String,String>> getListHd(Map<String,Object> formData);
	public List<Map<String,String>> getListDetail(Map<String,Object> formData);
	public String saveReAgentSelect(Map<String,String>  formData, List<Object> gridData);
	public String saveAllAgentSel(Map<String,String>  formData, List<Object> gridData);
}
