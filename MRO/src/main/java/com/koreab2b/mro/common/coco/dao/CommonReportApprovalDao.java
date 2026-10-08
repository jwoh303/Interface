package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonReportApprovalDao {	 
	
	// 리포트 자동화 품의상신 후 처리
	public String rptRequest(Map<String,String> formData);
	// 리포트 자동화 결재 반려 후 처리
	public String rptReject(Map<String,String> formData);
	// 리포트 자동화 결재 상신취소 후 처리
	public String rptCancel(Map<String,String> formData);
	// 리포트 자동화 결재 승인 후 처리
	public String rptApproval(Map<String,String> formData);
	// 결재정보 조회(페이징)
	public List<Map<String,String>> approvalReportListPop(Map<String,String> formData);
}
