package com.koreab2b.mro.master.cmcl.dao;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public interface MasterCmClSmartBillUploadingCreationDao {
	
	// 스마트빌 전송상태 업데이트
	public String saveXXSBDtiStatusInfo(Map<String,String>  formData);
	// 스마트빌 전송상태 업데이트
	public String sendSuccessSmartbill(Map<String,String>  formData);
	// 스마트빌 전송실패 업데이트
	public String errorSendSmartBill(Map<String,String>  formData);
	// 취소처리 성공
	public String cancleSuccessSmartBill(Map<String,String>  formData);
	// 전송양식 생성
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueFormatInfo(Map<String,String> formData);
	
	// 전송양식 생성
	public List<Map<String,String>> SendARMasterCmClSalesTaxsheetIssueRegList(Map<String,String> formData, HttpServletRequest req, HttpServletResponse pResponse);
	
	// 역발행 메일 요청
	public List<Map<String,String>> selectMasterCmClsendApRMailPop(Map<String,String> formData);
}
