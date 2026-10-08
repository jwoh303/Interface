package com.koreab2b.mro.buyer.mppo.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoOrderReqReceiptService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);	
	// 저장
	public String savePrRecvReturnReasonReg(Map<String,String>  formData);
	// 부서이관
	public String saveDeptTramsfer(Map<String,String>  formData); 
	
	public String saveSerPrReturn(Map<String,String>  formData);
	public String saveSerPrDetailReturn(Map<String,String>  formData);
	public String saveSetSavePR(Map<String,String>  formData);
	public String saveInsertMergePxPo(Map<String,String>  formData);
	public String saveInsertMergePxPoDetail(Map<String,String>  formData);
	public String saveChangeMergePxPo(Map<String,String>  formData);
	
	public List<Map<String,String>> getBuyerAdminBdgtTempQtyCheck(Map<String,String>  formData);	
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderCheck(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderDetailCheck(Map<String,String>  formData);
	
	
	// 홍대용 조회
	public List<Map<String,String>> getBuyerMpPoHongikOrderReqReceiptList(Map<String,String>  formData);	
	// 구매요청접수
	public List<Map<String,String>> getBuyerMpPoOrdePrReqReceiptList(Map<String,String>  formData);
	//관리번호 저장
	public String saveRefPrNo(Map<String,String>  formData);
}
