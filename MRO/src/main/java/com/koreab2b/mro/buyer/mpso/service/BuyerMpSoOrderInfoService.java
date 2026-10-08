package com.koreab2b.mro.buyer.mpso.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoOrderInfoService {
	// 조회 getBuyerShoppingCartOrderListConfirmList2
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getList_v2(Map<String,String>  formData);	
	
	
	public List<Map<String,String>> getOrderInfo_v2(Map<String,String>  formData);	
	public List<Map<String,String>> getPasslnInfo_v2(Map<String,String>  formData);	
	/**
	 * 선입고발주 제외대상 업체 조회
	 * @param formData
	 * @return
	 */
	public String getNotPreGoodsCompany(Map<String,String>  formData);
	
	
	public String buyerNewCreateBenit(Map<String,String>  formData);
	public String aekyApprPriceSend(Map<String,String>  formData);	   
	public String buyerNewCreateOrder(Map<String,String>  formData);
	public String buyerNewCreateOrder_v2(Map<String,String>  formData);
	public List<Map<String, String>> newBuyerCommonPassbiz(Map<String,String>  formData);	 
	public String adminBuyerMasterPrCreateMailReg(Map<String,String>  formData);	 
	public List<Map<String, String>> cowayBuyerAdminBdgtTempCheck(Map<String,String>  formData);	 
	public List<Map<String, String>> buyerAdminBdgtTempCheck(Map<String,String>  formData);	 
	
	
	public String getPassCheck(Map<String,String>  formData);	   
	public List<Map<String, String>> getCompanyPassflag(Map<String,String>  formData);	  
	
	
	public List<Map<String, String>> buyerAdminBdgtTempOrderCheck(Map<String,String>  formData);	 
	public String buyerNewReCreateOrder(Map<String,String>  formData);
	public List<Map<String, String>> getCowayPointChk(String com_code, String msg, String userId);
	public void insertCowayPointHistory(Map<String, Object> data);	 
	
	/**
	 * 고객사에서 그룹웨어를 사용할 경우 전송할 정보를 저장한다.
	 * @param formData
	 * @return
	 */
	public Map<String, String> buyerNewCreateGroupware(Map<String,String>  formData);
	public List<Map<String, String>> getQuratisGetContents(Map<String, String> formData);
	public List<Map<String, String>> getHongikGetContents(Map<String, String> formData);
	
	public String updateBuyerApItemType(Map<String, String> pMap);
	
	
	
	
}
