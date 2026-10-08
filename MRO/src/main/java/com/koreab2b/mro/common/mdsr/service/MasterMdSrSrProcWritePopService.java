package com.koreab2b.mro.common.mdsr.service;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrProcWritePopService {
	// 조회
	public List<Map<String,String>> getMasterMdSrSrProcWritePop(Map<String,Object>  formData);

	// 저장
	public String saveMasterMdSrSrProcWritePop(Map<String,String>  formData);
}
