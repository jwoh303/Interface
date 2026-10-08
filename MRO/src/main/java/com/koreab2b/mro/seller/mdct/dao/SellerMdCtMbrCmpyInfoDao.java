package com.koreab2b.mro.seller.mdct.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdCtMbrCmpyInfoDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);
	// 납품가능지역 조회
	public List<Map<String,String>> selectDelyAreaList(Map<String,String> formData);
	// 저장 (레거시)
	public String updateSelectedData(Map<String,String> formData);
	// 저장 (리뉴얼)
	public String updateSelectedData_v2(Map<String,String> formData);
}
