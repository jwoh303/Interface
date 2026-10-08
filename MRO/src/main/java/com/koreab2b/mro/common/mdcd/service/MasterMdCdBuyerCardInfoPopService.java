package com.koreab2b.mro.common.mdcd.service;

import java.util.List;
import java.util.Map;

public interface MasterMdCdBuyerCardInfoPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 거래금액 조회
	public List<Map<String,String>> getAcountList(Map<String,String>  formData);
	
	// 주요활동내역 조회
	public List<Map<String,String>> getVisitList(Map<String, Object>  formData);
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData);
	
	// 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
}
