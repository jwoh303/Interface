package com.koreab2b.mro.master.mdam.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdAmInfoReferenceDao {

	public List<Map<String,String>> selectList(Map<String,String> formData);
	public Map<String,String> getDetailList(Map<String,String> formData);
	public void updateDetailList(Map<String,String>  formData);
	public void deleteDetailList(Map<String,String>  formData);
	public void insertDetailList(Map<String,String>  formData);
}
