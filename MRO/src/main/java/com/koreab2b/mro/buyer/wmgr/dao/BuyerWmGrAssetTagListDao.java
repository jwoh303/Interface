package com.koreab2b.mro.buyer.wmgr.dao;

import java.util.List;
import java.util.Map;

public interface BuyerWmGrAssetTagListDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
}
