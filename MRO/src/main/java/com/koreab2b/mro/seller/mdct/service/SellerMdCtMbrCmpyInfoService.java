package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

public interface SellerMdCtMbrCmpyInfoService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	//  납품가능 지역
	public List<Map<String,String>> getDelyAreaList(Map<String,String>  formData);
	// 저장 (레거시)
	public String updateSelectedData(Map<String,String>  formData);
	// 저장 (리뉴얼)
	public String updateSelectedData_v2(Map<String,String>  formData);
}
