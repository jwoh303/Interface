package com.koreab2b.mro.common.mdsr.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrProcWritePopDao {
	// 조회
	public List<Map<String,String>> getMasterMdSrSrProcWritePop(Map<String,Object> formData);
	
	// 저장
	public String saveMasterMdSrSrProcWritePop(Map<String,String>  formData);
}
