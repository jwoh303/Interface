package com.koreab2b.mro.master.wmgi.service;

import java.util.List;
import java.util.Map;

import org.springframework.util.MultiValueMap;

public interface MasterWmGiReleaseDirectionsTranService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 일괄리스트조회
	public List<Map<String,String>> getBpList(Map<String,Object>  param);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 엑셀 리스트조회
	public List<Map<String,String>> getExcelList(Map<String,Object>  param);
	
	// 일양, 한진택배 여부 조회
	public String getDeliCompany(Map<String, String> pMap);

}
