package com.koreab2b.mro.seller.mpcl.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpClPositionCodeDao {
	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
