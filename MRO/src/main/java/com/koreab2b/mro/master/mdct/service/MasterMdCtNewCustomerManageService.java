package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCtNewCustomerManageService {
	
	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	//잠재고객 등록
	public String saveMasterMdCtNewCustomer(Map<String,String>  formData);
	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	//잠재고객 상세 조회
	public List<Map<String,String>> getDetailList(Map<String,String>  formData);
	//잠재고객 수정
	public String updateMasterMdCtNewCustomer(Map<String,String>  formData);
	//잠재고객 종결
	public String endMasterMdCtNewCustomer(Map<String,String>  formData);
	//잠재고객 사전영업 완료
	public String saveMasterMdCtNewCustomerMtComp(Map<String,String>  formData);
	//기업정보 업데이트
	public String updateMasterMdCtMSTNewCustomer(Map<String,String>  formData);	
	
}
