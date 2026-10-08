package com.koreab2b.mro.buyer.mdcm.service;

import java.util.List;
import java.util.Map;

public interface BuyerMdCmGoodsLisService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	public List<Map<String,String>> getListCATEGORY_TEXT(Map<String,String>  formData);
	public List<Map<String,String>> getListMAKER_NAME(Map<String,String>  formData);
	// 상세 조회
	public List<Map<String,String>> getCatalogDisplayMain(Map<String,String>  formData);
	public List<Map<String,String>> getCatalogDisplayMain_v2(Map<String,String>  formData);
	public List<Map<String,String>> getCatalogDisplayPCOMain(Map<String,String>  formData);
	public List<Map<String,String>> getItemSeries(Map<String,String>  formData);
	public List<Map<String,String>> getItemSeries_v2(Map<String,Object>  formData);
	public List<Map<String,String>> getItemAttrCheck(Map<String,String>  formData);
	
	
	// 저장
	public String saveBuyerMdCmGoodsLisList(Map<String,String>  formData);
	public String saveBuyerMdCmGoodsLisList_v2(Map<String,String>  formData);
}
