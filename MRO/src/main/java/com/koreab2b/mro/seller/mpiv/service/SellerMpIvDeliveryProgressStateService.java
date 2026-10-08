package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryProgressStateService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	// 납품예정일 변경요청
	public String updateSellerMpIvDsDateChangeReq(Map<String,String>  pMap);
	
	// 수주접수 초기화요청
	public String updateSellerMpIvIvInfoChangeReq(Map<String,String>  pMap);
	
	// 리뉴얼 > 조회
	public List<Map<String,String>> getSellerMpIvDeliveryProgressStateList_v2(Map<String,Object>  formData);
}
