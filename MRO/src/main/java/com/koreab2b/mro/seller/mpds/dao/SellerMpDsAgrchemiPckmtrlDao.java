package com.koreab2b.mro.seller.mpds.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpDsAgrchemiPckmtrlDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 조회(Sub)
	public List<Map<String,String>> selectListSub(Map<String,String> formData);
	
}
