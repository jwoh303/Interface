package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrWarehousingLisService {
	
	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v3(Map<String,Object>  formData);
	// 저장
	public String updateSelectedData(Map<String,String> formData);
	public String updateSelectedData_v3(Map<String,String> formData);
	// 마감 EXCEL 다운로드
	public List<Map<String,String>> getCloseExcelList(Map<String,String> formData);
	
	// 관리번호별 집계 팝업
	public List<Map<String,String>> getRefTotalList(Map<String,String> formData);
	
	// 한컴 ERP 양식
	public List<Map<String,String>> getHLCList(Map<String,String> formData);
}
