package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoOrderInfoDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> selectList_v2(Map<String,String> formData);
	public List<Map<String,String>> getOrderInfo_v2(Map<String,String> formData);
	public List<Map<String,String>> getPasslnInfo_v2(Map<String,String> formData);
	
	//선입고발주 제외대상 업체 조회
	public String getNotPreGoodsCompany(Map<String,String>  formData);	 
	
	public String createBuyerNewCreateBenit(Map<String,String>  formData);	
	public String aekyApprPriceSend(Map<String,String>  formData);
	public String createBuyerNewCreateOrder(Map<String,String>  formData);
	public String createBuyerNewCreateOrder_v2(Map<String,String>  formData);
	public List<Map<String, String>> selectNewBuyerCommonPassbiz(Map<String,String>  formData);	 
	public String createAdminBuyerMasterPrCreateMailReg(Map<String,String>  formData);	 
	public List<Map<String, String>> selectCowayBuyerAdminBdgtTempCheck(Map<String,String>  formData);	 
	public List<Map<String, String>> selectBuyerAdminBdgtTempCheck(Map<String,String>  formData);	 
	
	// 구매발주
	public String insertMergePxPo(  Map<String,String>  formData);
	// 고객사별구매발주
	public String insertMergePxPoDetail(  Map<String,String>  formData);
	public String changeMergePxPo(  Map<String,String>  formData);
	
	public String selectPassCheck(Map<String,String>  formData);	  
	public List<Map<String, String>> selectCompanyPassflag(Map<String,String>  formData);		 	
	
	
	public String setPassPr(Map<String,String>  formData);	  
	public String setPxPoOrder(Map<String,String>  formData);	  
	public String getTempBdgtUpdateApprovalReturn(Map<String,String>  formData);	  
	
	public String bizCancel(Map<String, String> _pMap); 
	
	
	public String getOrderNo(String cmpyId, String docType) throws Exception;
	
	public List<Map<String, String>> buyerAdminBdgtTempOrderCheck(Map<String,String>  formData);	 
	public String buyerNewReCreateOrder(Map<String,String>  formData);	   
	
	
	/*
	 * 메일 SMS 발송
	 */
	public void call_PKG_MAIL_REQ_PROC_MAIL_SEND_PO(Map<String,String>  formData);

	public List<Map<String, String>> getCowayPointChk(String com_code, String msg, String userId);

	public void insertCowayPointHistory(Map<String, Object> data);

	/**
	 * 고객사에서 그룹웨어를 사용할 경우 주문 이력을 저장한다.
	 * @param formData
	 * @return
	 */
	public Map<String, String> createNewCreateGroupware(Map<String,String>  formData);
	public List<Map<String, String>> getQuratisContentsList(Map<String,String>  formData);
	public List<Map<String, String>> getHongikContentsList(Map<String,String>  formData);

	public String updateApItemType(Map<String, String> pMap);
	
}
