package com.koreab2b.mro.seller.mdct.dao;

import java.util.List;
import java.util.Map;

public interface SellerMdCtChemicalMatMngDao {

	// 리스트 조회
	public List<Map<String,String>> selectList(Map<String,Object> param);

	// 리뉴얼 탭1 - MSDS 전체 조회
	public List<Map<String,String>> selectMSDSList(Map<String,Object> param);

	// 리뉴얼 탭2 - MSDS 제출요청 조회
	public List<Map<String,String>> selectMSDSSubmitRequestList(Map<String,Object> param);

}
