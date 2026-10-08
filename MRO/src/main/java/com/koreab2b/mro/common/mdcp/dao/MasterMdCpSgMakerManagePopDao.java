package com.koreab2b.mro.common.mdcp.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCpSgMakerManagePopDao {
	
	//조회
	public List<Map<String,String>> selectCompyList(Map<String,String> formData);
		
	// 리스트 조회
	public List<Map<String,String>> selectKepSgList(Map<String,Object> param);
	
	// 리스트 조회
	public List<Map<String,String>> selectKepMkList(Map<String,Object> param);
	
	// 저장
	public String updateRemarkData(Map<String,String>  formData);
		
	// 저장
	public String updateKepMkData(Map<String,String>  formData, List<Object> gridData);
	
	// Mk승인
	public String updateConfMkData(Map<String, String>  formData, List<Object> gridData);
		
	// Mk복원
	public String updateModMkData(Map<String, String>  formData, List<Object> gridData);
		
	// SG삭제
	public String deleteKepSgData(Map<String, String>  formData, List<Object> gridData);
	
	// Mk삭제
	public String deleteKepMkData(Map<String, String>  formData, List<Object> gridData);

}
