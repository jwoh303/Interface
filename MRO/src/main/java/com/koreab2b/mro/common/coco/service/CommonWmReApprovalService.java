package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonWmReApprovalService {	 
	 
	public String approval(Map<String, String> _pMap);  
	public String cancel(Map<String, String> _pMap); 
	public String request(Map<String, String> _pMap); 
	//결재화면조회
	public List<Map<String,String>>   approvalWmReListPop(Map<String,String>  _pMap);
	//오류재실행
	public String runlWmReListPop(Map<String, String> formData);
	
}
