package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmGoodsCategService {
	// 코드 조회
	public List<Map<String,String>> getList(Map<String,Object>  param);
	// 코드 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public int updateBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData);
	
	// 코드 삭제
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData);
	public int delBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData);
	
	// 코드 추가
	public int saveBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData);
	
}
