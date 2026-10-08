package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;


public interface CommonNgNsRcPaApprovalService {	 
	 
	public String approval(Map<String, String> _pMap);  
	public String approval_v2(Map<String, String> _pMap);
	public String cancel(Map<String, String> _pMap); 
	 
	public String request(Map<String, String> _pMap); 
	public String request_temp(Map<String, String> _pMap); 
	 
	public String setRqdtRecvFlagToNg(Map<String, String> _pMap);
	
	
	public List<Map<String,String>>   approvalNgListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalNsListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalNgListPop_v2(Map<String,Object>  _pMap);
	public List<Map<String,String>>   approvalNsListPop_v2(Map<String,Object>  _pMap);
	public List<Map<String,String>>   approvalPaListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalRcListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalSoListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalNcaListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalScaListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalCaListPop(Map<String,String>  _pMap);
	public List<Map<String,String>>   approvalSrListPop(Map<String,String>  _pMap);
	//재계약 품의화면
	public List<Map<String,String>> approvalRctListPop(Map<String,String>  _pMap);
	
	// 카탈로그등록요청 소싱제출
	public List<Map<String,String>>   approvalCaRqListPop(Map<String,String>  _pMap);
	// 카탈로그 상태 변경
	public List<Map<String,String>>   approvalCaStListPop(Map<String,String>  _pMap);
	
}
