package com.koreab2b.mro.buyer.mpso.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpSoDlvryInfoDao {
 
	public List<Map<String, String>>  getList(Map<String,String>  formData); 
	 
	public String checkZipCode(Map<String,String> formData);
	
	// 기본 배송정보 입력 
	public String setUserInfoUpdate(Map<String,String>  formData);
	

	// 수령희망일 입력
	public List<Map<String, String>>  getBuyerMpSoRecvDateRegisterPop(Map<String,String>  formData); 
	
	
	// 배송조회
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoStatusList(Map<String,String>  formData); 
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoDtlList(Map<String,String>  formData);
	public List<Map<String, String>>  getBuyerMpSoDlvryInfoDtlList_v2(Map<String,String>  formData);
	// 부서조회(ICOMCOD2 C001)
	public String getdeptYn(Map<String, String> formData); 
	
}
