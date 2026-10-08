package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

import org.springframework.util.MultiValueMap;

public interface MasterMdCdCompanyAddressPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);

	public Map<String,String> deleteData(Map<String,String>  formData);

	public Map<String,String> saveData(Map<String,String>  formData);

	public Map<String,String> addData(Map<String,String>  formData);
	
}
