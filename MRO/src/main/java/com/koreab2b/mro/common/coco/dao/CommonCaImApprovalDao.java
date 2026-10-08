package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonCaImApprovalDao {	 
	
	// 카탈로그변경 결재 반려 후 처리(IM)
	public String imReject(Map<String,String> formData);
	// 카탈로그변경 품의상신 후 처리(IM)
	public String imRequest(Map<String,String> formData);
	// 카탈로그변경 결재 상신취소 후 처리(IM)
	public String imCancel(Map<String,String> formData);
	// 카탈로그변경 결재 승인 후 처리(IM)
	public String imApproval(Map<String,String> formData);
	// 결재정보 조회(페이징)
	public List<Map<String,String>> imResultList(Map<String,String> formData);
}
