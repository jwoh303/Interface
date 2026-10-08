package com.koreab2b.mro.buyer.wmgr.service;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrWarehousingTotService {
	
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingTotList_v2(Map<String,Object>  formData);
	
	// 팝업조회
	public List<Map<String,String>> getPopList(Map<String,String>  formData);
	public List<Map<String,String>> getPopList_v2(Map<String,Object>  formData);
}
