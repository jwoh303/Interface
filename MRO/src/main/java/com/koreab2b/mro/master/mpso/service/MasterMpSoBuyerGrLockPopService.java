package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoBuyerGrLockPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData);
	
	// 입고잠금
	public String saveGrLock(Map<String, String> formData);
}