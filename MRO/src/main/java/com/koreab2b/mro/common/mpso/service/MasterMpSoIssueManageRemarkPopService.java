package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoIssueManageRemarkPopService {
	
	// 조회
	public Map<String,String> RemarkPopItem(Map<String,String>  formData);
	public Map<String,String> RemarkPopPOHD(Map<String,String>  formData);
	public List<Map<String,String>> RemarkPopIVDT(Map<String,String>  formData);
	public List<Map<String,String>> RemarkPopPOMN(Map<String,String> formData);
	public Map<String,String> RemakrRPTURL(Map<String,String> formData);
	public List<Map<String, String>> getList(Map<String, Object> formData);
	//	 저장
	public String saveRemark(Map<String, String> formData);
	public String saveMemo(Map<String, String> formData);
}
