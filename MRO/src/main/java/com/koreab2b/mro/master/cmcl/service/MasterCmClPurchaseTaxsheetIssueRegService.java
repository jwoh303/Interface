package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

public interface MasterCmClPurchaseTaxsheetIssueRegService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	// SAP 전송
	public String updateAPsendData(Map<String,String>  formData, List<Object> gridData);
	
	// SAP 전송취소
	public String updateAPreverseData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData);

	// 역발행요청삭제
	public String delApMasterCmClPurchaseTaxsheetIssueRegList(Map<String,String>  formData, List<Object> gridData);
	
	//전송
	public String sendApSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 정발행 메일 요청
	public String sendApMailSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 역발행 메일 요청
	public List<Map<String,String>> getMasterCmClsendApRMailPop(Map<String,String>  formData);
}
