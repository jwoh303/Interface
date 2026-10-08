package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonMdCmStndApprovalService {	 
	 
	public String approval(Map<String, String> _pMap);  
	public String cancel(Map<String, String> _pMap); 
	public String request(Map<String, String> _pMap); 
	
}
