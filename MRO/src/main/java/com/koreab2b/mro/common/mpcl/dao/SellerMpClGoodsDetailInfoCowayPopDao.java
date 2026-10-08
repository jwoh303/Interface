package com.koreab2b.mro.common.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClGoodsDetailInfoCowayPopDao {

	// 조회
	public List<Map<String,String>> selectHdList(Map<String,String> formData);

	// 조회
	public List<Map<String,String>> selectDtList(Map<String,String> formData);
}
