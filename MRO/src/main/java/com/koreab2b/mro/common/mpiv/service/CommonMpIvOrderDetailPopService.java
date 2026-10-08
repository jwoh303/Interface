package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface CommonMpIvOrderDetailPopService {
	
	public Map<String,String> getInfo(Map<String,String> formData);
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getCommonMpIvBuyerOrderDetailListPop_v2(Map<String,Object>  formData);
}
