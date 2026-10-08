package com.koreab2b.mro.master.wmgi.dao;

import java.util.List;
import java.util.Map;

import org.springframework.util.MultiValueMap;

public interface MasterWmGiReleaseDirectionsTranDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	// 일괄리스트 조회
	public List<Map<String,String>> 	selectBpList(Map<String,Object> param);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);

	// 엑셀 리스트 조회
	public List<Map<String,String>> selecExceltList(Map<String,Object> param);
	
	// 일양, 한진택배 여부 조회
	public String getDeliCompany(Map<String, String> param);
}
