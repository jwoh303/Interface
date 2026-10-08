package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCmHarmfulChemistryService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	//실적데이터 생성
	public String createMasterMdCmHarmfulChemistry(Map<String, String> formData);
}
