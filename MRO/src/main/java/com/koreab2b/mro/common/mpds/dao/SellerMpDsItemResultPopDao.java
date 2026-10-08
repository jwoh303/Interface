package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpDsItemResultPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

}
