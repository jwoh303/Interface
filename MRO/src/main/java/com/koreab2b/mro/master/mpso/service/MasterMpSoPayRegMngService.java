package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.util.MultiValueMap;

public interface MasterMpSoPayRegMngService {
	// 리스트조회
	public List<Map<String, String>> getMasterMpSoPayRegMngList(Map<String, Object> param);
	
	// 저장
	public String updateSelectedData(Map<String, String> formData, List<Object> gridData);
	
	// 예정일 변경 사유 저장
	public String saveRemark(Map<String, String> param);
	
	// 삭제
	public String deleteSelectedData(Map<String, String> formData, List<Object> gridData);
	
	// 품의 상신
	public String approvalSelectedData(Map<String, String> formData, List<Object> gridData);

	

	
	

}
