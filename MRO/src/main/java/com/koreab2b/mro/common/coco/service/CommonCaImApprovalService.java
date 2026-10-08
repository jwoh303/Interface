package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonCaImApprovalService {	 
	// 결재 승인
	public String approval(Map<String, String> _pMap);
	// 상신 취소
	public String cancel(Map<String, String> _pMap); 
	// 품의상신
	public String request(Map<String, String> _pMap); 

	public List<Map<String,String>> approvalImListPop(Map<String,String>  _pMap);
	
	
}
