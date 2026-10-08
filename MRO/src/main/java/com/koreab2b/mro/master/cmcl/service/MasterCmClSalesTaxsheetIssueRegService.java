package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface MasterCmClSalesTaxsheetIssueRegService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	
	// SAP 전송
	public String updateARsendData(Map<String,String>  formData, List<Object> gridData);
	
	// SAP 전송취소
	public String updateARreverseData(Map<String,String>  formData, List<Object> gridData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	public String delSelectedData_v2(Map<String,String>  formData, List<Object> gridData);
	// 전송
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueRegList(Map<String,String>  formData, HttpServletRequest req, HttpServletResponse pResponse);
	// 전송
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueFormat(Map<String,String>  formData);
	// 세금계산서 삭제
	public String delSelectedSbData(Map<String,String>  formData, List<Object> gridData);
}
