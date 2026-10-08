package com.koreab2b.mro.seller.mpiv.dao;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliChangeReqDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	public List<Map<String,String>> getSellerMpIvDeliChangeReqList_v2(Map<String,Object> formData);
	
	
	// 취소요청
	public String updateSellerMpIvDeliChangeReqCancel(Map<String,String> pMap);
	
	// 요청사항 상세 팝업
	public List<Map<String,String>> getSellerMpIvDeliChangeReqDetailPop(Map<String,String>  pMap);
}
