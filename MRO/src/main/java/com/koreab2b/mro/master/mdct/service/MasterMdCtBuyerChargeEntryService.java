package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtBuyerChargeEntryService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	
	// 담당자 중복 체크
	public String getKepUserIdCheck(Map<String,String>  formData, List<Object> gridData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
}
