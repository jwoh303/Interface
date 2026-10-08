package com.koreab2b.mro.common.mdct.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdCtPrivateInfoPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
