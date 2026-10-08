package com.koreab2b.mro.seller.mdct.service;

import java.util.List;
import java.util.Map;

public interface SellerMdCtChemicalMatMngService {

	// 리스트조회
	public List<Map<String,String>> getList(Map<String,Object>  param);

	// 리뉴얼 탭1 - MSDS 전체 조회
	public List<Map<String,String>> getMSDSList(Map<String,Object> param);

	// 리뉴얼 탭2 - MSDS 제출요청 조회
	public List<Map<String,String>> getMSDSSubmitRequestList(Map<String,Object> param);
}
