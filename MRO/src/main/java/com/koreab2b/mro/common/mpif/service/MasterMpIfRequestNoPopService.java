package com.koreab2b.mro.common.mpif.service;

import java.util.List;
import java.util.Map;

public interface MasterMpIfRequestNoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  formData);

	// 조회(상세목록)
	public List<Map<String,String>> getDetailList(Map<String,Object>  formData);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 단가임시저장
	public Map<String,String> InsertSelectedPriceData(Map<String,String>  formData, List<Object> gridData);

	// 구매발주
	public String updateSelectedDataPo(Map<String,String>  formData, List<Object> gridData);

}
