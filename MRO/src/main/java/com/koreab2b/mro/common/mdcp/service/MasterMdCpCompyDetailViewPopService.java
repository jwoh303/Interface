package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCpCompyDetailViewPopService {
	// 조회
	public List<Map<String,String>> getUserList(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getCompyList(Map<String,String>  formData);
}
