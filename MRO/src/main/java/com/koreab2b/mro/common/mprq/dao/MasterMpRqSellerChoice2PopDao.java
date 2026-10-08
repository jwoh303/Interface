package com.koreab2b.mro.common.mprq.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpRqSellerChoice2PopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);
	public List<Map<String,String>> getListHd(Map<String,Object> formData);
	public List<Map<String,String>> getListDetail(Map<String,Object> formData);
	public String saveReAgentSelect(Map<String,String>  formData, List<Object> gridData);
	public String saveAllAgentSel(Map<String,String>  formData, List<Object> gridData);
}
