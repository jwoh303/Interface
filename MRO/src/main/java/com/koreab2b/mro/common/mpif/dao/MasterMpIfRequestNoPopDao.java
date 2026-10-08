package com.koreab2b.mro.common.mpif.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpIfRequestNoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> formData);

	// 조회(상세)
	public List<Map<String,String>> selectDetailList(Map<String,Object> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 단가임시저장
	public Map<String,String> InsertSelectedPriceData(Map<String,String>  formData, List<Object> gridData);

	// 구매발주
	public String updateSelectedDataPo(Map<String,String>  formData, List<Object> gridData);
	
}
