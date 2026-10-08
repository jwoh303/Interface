package com.koreab2b.mro.buyer.mppo.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoOrderReqReceiptDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	
	// 저장
	public String savePrRecvReturnReasonReg(Map<String,String> formData);
	
	// 부서이관
	public String saveDeptTramsfer(Map<String,String>  formData);
	
	public String saveSerPrReturn(Map<String,String>  formData);
	public String saveSerPrDetailReturn(Map<String,String>  formData);
	public String saveSetSavePR(Map<String,String>  formData);
	public String saveInsertMergePxPo(Map<String,String>  formData);
	public String saveChangeMergePxPo(Map<String,String>  formData);
	
	public List<Map<String,String>> getBuyerAdminBdgtTempQtyCheck(Map<String,String>  formData);	
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderCheck(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerAdminBdgtTempOrderDetailCheck(Map<String,String>  formData);
	// 홍대용조회
	public List<Map<String,String>> selectHongikList(Map<String,String> formData);
	// 구매요청PR기준 리스트조회
	public List<Map<String,String>> selectMpPoOrdePrReqReceiptList(Map<String,String> formData);
	//관리번호 저장
	public String saveRefPrNo(Map<String,String>  formData);
	
}
