package com.koreab2b.mro.seller.mpcl.service;

import java.util.List;
import java.util.Map;

public interface SellerMpClLogisRateDetailService {

	// 리스트조회 (레거시)
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 리스트조회 (리뉴얼)
	public List<Map<String,String>> getList_v2(Map<String,Object>  param);
	public List<Map<String,String>> getList_v3(Map<String,Object>  param);
}
