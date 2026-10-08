package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface MasterCmClSalesTaxsheetIssueRegDao {
	
	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);
	
	// 리스트 조회
//	public List<Map<String,String>> selectARsendList(Map<String,String>  formData);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// IF 저장 - 전송
	public void saveARsendData(Map<String,String>  formData);
	
	// SAP 전송
	public String sendARsendData(Map<String,String>  formData);
	
	// IF 저장 - 전송취소
	public void saveARreverseData(Map<String,String>  formData);
	
	// SAP 전송취소
	public String sendARreverseData(Map<String,String>  formData);

	// 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String deleteSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	// 세금계산서전송삭제
	public String delSelectedSbData(Map<String,String>  formData, List<Object> gridData);	
	// 전송양식 생성
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueFormat(Map<String,String> formData);
	
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueRegList(Map<String,String>  formData, HttpServletRequest req, HttpServletResponse pResponse);

}
