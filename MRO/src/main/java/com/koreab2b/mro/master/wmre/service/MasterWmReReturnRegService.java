package com.koreab2b.mro.master.wmre.service;

import java.util.List;
import java.util.Map;

public interface MasterWmReReturnRegService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	// 수주접수이력체크
	public List<Map<String,String>> getPorsYn(Map<String,String>  formData);
	// 계산서발행체크
	public List<Map<String,String>> getArApYn(Map<String,String>  formData);
	public List<Map<String,String>> getArApYn_v2(Map<String,String>  formData);
	// 입고 계산서 체크.
	public List<Map<String,String>> getIvGrYn(Map<String,String>  formData);
	// 발주취소
	public Map<String,String> saveMasterWmReCancleReturn(Map<String,String>  formData, List<Object> gridData);
	
	// 반품일괄종결
	public String updateEndAllData(Map<String,String>  formData, List<Object> gridData);

}
