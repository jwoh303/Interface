package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdctNewReBuyerService {
	
	// 전체 조회
	public List<Map<String,String>> getAllList(Map<String,Object>  param);
	
	// 개인 조회
	public List<Map<String,String>> getIndvList(Map<String,Object>  param);
}