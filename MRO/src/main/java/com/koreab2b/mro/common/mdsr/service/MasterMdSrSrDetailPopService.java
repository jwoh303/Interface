package com.koreab2b.mro.common.mdsr.service;

import java.util.List;
import java.util.Map;

public interface MasterMdSrSrDetailPopService {
	// 조회
	public List<Map<String,String>> getMasterMdSrSrDetailPop(Map<String,Object>  formData);

	// 저장
	public String saveMasterMdSrSrDetailPop(Map<String,String>  formData);
	// 입고발주조회
	public List<Map<String,String>> getExcelMasterPoGrList(Map<String,Object>  formData);
	// 견적조회
	public List<Map<String,String>> getExcelMasterReList(Map<String,Object>  formData);
}
