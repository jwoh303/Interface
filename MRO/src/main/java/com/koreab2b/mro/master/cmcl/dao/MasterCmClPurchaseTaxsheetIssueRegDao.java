package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

public interface MasterCmClPurchaseTaxsheetIssueRegDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String updateSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	
	// 전송 - IF 저장
	public void saveAPsendData(Map<String,String>  formData);
	
	// 전송 - SAP 전송
	public String sendAPsendData(Map<String,String>  formData);
	
	// 전송취소 - IF 저장
	public void saveAPreverseData(Map<String,String>  formData);
	
	// 전송취소 - SAP 전송
	public String sendAPreverseData(Map<String,String>  formData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String deleteSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	//역발행요청 삭제
	public String delApMasterCmClPurchaseTaxsheetIssueRegList(Map<String,String>  formData, List<Object> gridData);
	
	// 전송
	public String sendApSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 정발행 요청 메일
	public String sendApMailSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// 역발행 요청 메일
	public List<Map<String,String>> selectMasterCmClsendApRMailPop(Map<String,String> formData);
}
