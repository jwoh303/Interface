package com.koreab2b.mro.master.mdct.dao;

import java.util.List;
import java.util.Map;

public interface MasterMdCtNewCustomerBidManageDao {
	
	// 잠재고객 입찰정보조회
	public List<Map<String,String>> getDetailList(Map<String,String> formData);
	//잠재고객 입찰정보저장
	public String saveMasterMdCtNewCustomerBidList(Map<String,String> formData);
	//잠재고객 입찰 취소
	public String cancleMasterMdCtNewCustomerBidList(Map<String,String> formData);
	// 잠재고객 셋업정보 조회
	public List<Map<String,String>> getSetupList(Map<String,String> formData);
	//잠재고객 셋업정보저장
	public String saveMasterMdCtNewCustomerSetList(Map<String,String> formData);
	// 잠재고객 계약정보 조회
	public List<Map<String,String>> getConList(Map<String,String> formData);
	//잠재고객 셋업취소
	public String cancleMasterMdCtNewCustomerSetList(Map<String,String> formData);
	//잠재고객 계약정보저장
	public String saveMasterMdCtNewCustomerConList(Map<String,String> formData);
	//잠재고객 계약 취소
	public String cancleMasterMdCtNewCustomerConList(Map<String,String> formData);
}
