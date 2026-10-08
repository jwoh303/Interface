package com.koreab2b.mro.common.mdcp.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCpSgMakerManagePopService {
	
	// 조회
	public List<Map<String,String>> getCompyList(Map<String,String>  formData);
	
	// 리스트조회
	public List<Map<String,String>> getKepSgList(Map<String,Object>  param);
	
	// 리스트조회
	public List<Map<String,String>> getKepMkList(Map<String,Object>  param);
	
	// 저장
	public String updateRemarkData(Map<String,String>  formData);
		
	// 저장
	public String updateKepMkData(Map<String,String>  formData, List<Object> gridData);
	
	// MK승인
	public String updateConfMkData(Map<String,String>  formData, List<Object> gridData);
	
	// MK복원
	public String updateModMkData(Map<String,String>  formData, List<Object> gridData);
		
	// SG삭제
	public String deleteKepSgData(Map<String,String>  formData, List<Object> gridData);
	
	// MK삭제
	public String deleteKepMkData(Map<String,String>  formData, List<Object> gridData);

}
