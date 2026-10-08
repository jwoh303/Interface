package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtNewCustomerBidManageService {
	
	// 잠재고객 입찰정보 조회
	public List<Map<String,String>> getDetailList(Map<String,String>  formData);
	//잠재고객 입찰정보 저장
	public String saveMasterMdCtNewCustomerBidList(Map<String,String>  formData);
	//잠재고객 입찰정보 취소
	public String cancleMasterMdCtNewCustomerBidList(Map<String,String>  formData);
	// 잠재고객 셋업정보 조회
	public List<Map<String,String>> getSetupList(Map<String,String>  formData);
	//잠재고객 셋업정보 저장
	public String saveMasterMdCtNewCustomerSetList(Map<String,String>  formData);
	//잠재고객 셋업정보 취소
	public String cancleMasterMdCtNewCustomerSetList(Map<String,String>  formData);
	// 잠재고객 계약정보 조회
	public List<Map<String,String>> getConList(Map<String,String>  formData);
	//잠재고객  계약정보 저장
	public String saveMasterMdCtNewCustomerConList(Map<String,String>  formData);
	//잠재고객 계약정보 취소
	public String cancleMasterMdCtNewCustomerConList(Map<String,String>  formData);
	
}
