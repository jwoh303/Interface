package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrWarehousingTotDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> getBuyerWmGrWarehousingTotList_v2(Map<String,Object> formData);
	// 팝업조회
	public List<Map<String,String>> selectPopList(Map<String,String> formData);
	public List<Map<String,String>> selectPopList_v2(Map<String,Object> formData);
}
