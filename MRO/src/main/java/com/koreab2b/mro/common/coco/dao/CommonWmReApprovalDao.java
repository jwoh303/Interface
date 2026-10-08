package com.koreab2b.mro.common.coco.dao;

import java.util.List;
import java.util.Map;

public interface CommonWmReApprovalDao {	 
	//반품발주취소
	public String wmreCancle(Map<String,String>  formData);
	//반품결재
	public String wmreApprovalA(Map<String,String>  formData);
	//반품반려
	public String wmreApprovalB(Map<String,String>  formData);
	//결재화면조회
	public List<Map<String,String>>   approvalWmReListPop(Map<String,String>  _pMap);
	// 오류재실행
	public String runlWmReListPop(Map<String,String>  formData);

}
