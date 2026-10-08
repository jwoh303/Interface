package com.koreab2b.mro.common.mpcl.service;

import java.util.List;
import java.util.Map;

public interface SellerMpClGoodsDetailInfoCowayPopService {
	// 조회
	public List<Map<String,String>> getHdList(Map<String,String>  formData);

	// 조회
	public List<Map<String,String>> getDtList(Map<String,String>  formData);
}
