package com.koreab2b.mro.seller.mpds.service;

import java.util.List;
import java.util.Map;

public interface SellerMpDsAgrchemiPckmtrlService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	// 조회(Sub)
	public List<Map<String,String>> getListSub(Map<String,String>  formData);
	
}
