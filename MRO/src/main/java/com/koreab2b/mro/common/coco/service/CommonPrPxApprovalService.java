package com.koreab2b.mro.common.coco.service;

import java.util.Map;


public interface CommonPrPxApprovalService {	 
	 
	public String approval(Map<String, String> _pMap);  
	public String cancel(Map<String, String> _pMap); 
	 
	public String request(Map<String, String> _pMap); 
	public String request_temp(Map<String, String> _pMap); 
	 
	 
	
}
