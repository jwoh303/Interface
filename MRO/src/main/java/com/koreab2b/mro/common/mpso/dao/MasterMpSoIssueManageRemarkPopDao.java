package com.koreab2b.mro.common.mpso.dao;

import java.util.List;
import java.util.Map;

public interface MasterMpSoIssueManageRemarkPopDao {

	// 조회
	public Map<String,String> selectCqDt(Map<String,String> formData);

	// 조회
	public Map<String,String> selectPoHd(Map<String,String> formData); 
	
	// 조회
	public List<Map<String,String>> selectIvDt(Map<String,String> formData);

	public List<Map<String, String>> selectPoMn(Map<String, String> formData);

	public List<Map<String, String>> selectList(Map<String, Object> formData);
	
	public Map<String, String> selectRptInfo(Map<String,String> formData);

	public String updateRemark(Map<String, String> formData);

	public String insertMemo(Map<String, String> formData);
	
}
