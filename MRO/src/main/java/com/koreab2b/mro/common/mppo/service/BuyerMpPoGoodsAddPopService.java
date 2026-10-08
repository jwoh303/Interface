package com.koreab2b.mro.common.mppo.service;

import java.util.List;
import java.util.Map;

public interface BuyerMpPoGoodsAddPopService {
	// 조회
	public List<Map<String,String>> getInfoList(Map<String,String>  formData);
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	
	// 상품추가
	public String saveSetItemAdd(Map<String,String>  formData);
	
	
	// 상품 추가 상세 조회
	public List<Map<String,String>> getCatalogDisplayMain(Map<String,String>  formData);
	public List<Map<String,String>> getItemSeries(Map<String,String>  formData);
	public List<Map<String,String>> categoryPathViewer(Map<String,String>  formData);
	

}
