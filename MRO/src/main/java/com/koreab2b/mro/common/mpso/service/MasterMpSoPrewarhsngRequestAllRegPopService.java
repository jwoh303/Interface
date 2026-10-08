package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoPrewarhsngRequestAllRegPopService {
	// 저장
	public String setExcelUp(Map<String,String>  formData);
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);
	
	// 선입고 요청 등록
	public String updateMasterMpSoPrewarhsngRequestAllRegPop(Map<String,String>  formData, List<Object> gridData);
	
}
