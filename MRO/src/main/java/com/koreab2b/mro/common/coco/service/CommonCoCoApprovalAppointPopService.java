package com.koreab2b.mro.common.coco.service;

import java.util.List;
import java.util.Map;

public interface CommonCoCoApprovalAppointPopService {
	public List<Map<String, String>> getApprovalMultiPathList(Map<String, String> pMap) ;
	
	public String setCommonCoCoApprovalInfo(Map<String,String> pMap) ;
	
	public void updateAppPathDefaultApproval(Map<String,String> pMap) ;
	
	public void insertAppPathCreate(Map<String,String> pMap) ;
	
	public void deleteAppPathRemove_appt(Map<String,String> pMap) ;
	
	public void deleteAppPathRemove_apse(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getApprovalMultiPathUserList(Map<String,String> pMap) ;
	
	public List<Map<String,String>> getApprovalMultiPathUserNm_arry(Map<String,String> pMap) ;
	
	public void deleteAppPathDetailRemove_all(Map<String,String> pMap) ;
	
	public void insertAppPathDetailCreate(Map<String,String> pMap) ;
	
	public String delCommonCoCoApprovalInfo(Map<String,String> pMap) ;
	
	public String regApproverInfoList(Map<String,String> pMap) ;
}
