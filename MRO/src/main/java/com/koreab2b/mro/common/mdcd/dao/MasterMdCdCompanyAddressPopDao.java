package com.koreab2b.mro.common.mdcd.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCdCompanyAddressPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	public Map<String,String> deleteData(Map<String, String> formData);

	public Map<String,String> saveData(Map<String, String> formData);

	public Map<String,String> addData(Map<String, String> formData);	
	
}
