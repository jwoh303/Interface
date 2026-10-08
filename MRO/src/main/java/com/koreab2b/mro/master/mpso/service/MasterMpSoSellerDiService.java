package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

public interface MasterMpSoSellerDiService {
	
	// 리스트조회
	public List<Map<String,String>> getMasterMpSoSellerDiList_v2(Map<String,Object>  param);

	// 저장
	public String saveMpSoSellerDiTaxType_v2(Map<String,String>  formData, List<Object> gridData);
	
	//재고합계금액 팝업 조회
	public List<Map<String,String>> getMasterMpSoSellerDiStockSumPopList_v2(Map<String,Object>  param);
}
