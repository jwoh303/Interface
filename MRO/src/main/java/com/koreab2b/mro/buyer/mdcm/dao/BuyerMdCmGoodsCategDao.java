package com.koreab2b.mro.buyer.mdcm.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmGoodsCategDao {

	// 코드 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 코드 저장
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData);
	public int updateBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData);
	

	// 코드 삭제
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData);
	public int delBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData);
	
	// 코드 추가
	public int saveBuyerMdAmGoodsCategLis_v2(Map<String,String>  formData);
}
