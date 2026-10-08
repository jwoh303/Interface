package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrWarehousingLisDao {

	// init
	public Map<String,String> getBuyerWmGrWarehousingLisInit(Map<String,String> formData);
		
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v2(Map<String,Object> formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingLisList_v3(Map<String,Object> formData);
	
	// 저장
	public String updateSelectedData(Map<String,String> formData);
	public String updateSelectedData_v3(Map<String,String> formData);
	// 마감 EXCEL 다운로드
	public List<Map<String,String>> selectCloseExcelList(Map<String,String> formData);
	
	// 관리번호별 집계 팝업
	public List<Map<String,String>> selectRefTotalList(Map<String,String> formData);
	
	// 한컴라이프 ERP 양식 다운로드
	public List<Map<String,String>> selectHLCERPList(Map<String,String> formData);
}
