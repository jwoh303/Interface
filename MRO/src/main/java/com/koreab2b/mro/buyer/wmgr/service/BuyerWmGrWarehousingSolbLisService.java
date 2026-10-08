package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrWarehousingSolbLisService {
	
	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingSolbLisList_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingSolbLisList_v3(Map<String,Object>  formData);
	// 저장
	public String updateSelectedData(Map<String,String> formData);
	public String updateSelectedData_v3(Map<String,String> formData);
	// 관리번호 변경 저장
	public String updateSolbRefNo(Map<String, String> pMap);

	// 입고 확정 및 취소
	public String updateSolbGrConfirm(Map<String, String> pMap);

	// 회계 확정 및 취소
	public String updateSolbDlConfirm(Map<String, String> pMap);
	
	// erp다운로드
	public List<Map<String, String>> getErpList(Map<String, String> pMap);
	
}
