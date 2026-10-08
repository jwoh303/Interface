package com.koreab2b.mro.common.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface CommonMpIvOrderDetailPopDao {
	
	public Map<String,String> selectInfo(Map<String,String> formData);
	
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> getCommonMpIvBuyerOrderDetailListPop_v2(Map<String,Object> formData);
}
