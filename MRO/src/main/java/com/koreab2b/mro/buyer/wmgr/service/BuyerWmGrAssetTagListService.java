package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrAssetTagListService {

	// 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	//저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
