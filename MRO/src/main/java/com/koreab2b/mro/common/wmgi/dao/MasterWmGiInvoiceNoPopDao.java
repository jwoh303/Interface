package com.koreab2b.mro.common.wmgi.dao;

import java.util.List;
import java.util.Map;

public interface MasterWmGiInvoiceNoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	public List<Map<String,String>> selectPop(Map<String,String> formData);
	
	public String selectDoosan(Map<String,String> formData);
	
	public List<Map<String,String>> getListDelevery(Map<String,Object> formData);
	
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	public String updateSelectedDataDelevery(Map<String,String>  formData, List<Object> gridData);
}
