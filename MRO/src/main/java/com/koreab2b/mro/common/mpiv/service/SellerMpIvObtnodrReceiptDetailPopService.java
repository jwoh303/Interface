package com.koreab2b.mro.common.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvObtnodrReceiptDetailPopService {
	
	// 수주접수 상세정보 조회
	public List<Map<String, String>> getDetailInfo(Map<String,String>  formData);

	// 수주접수 상세 리스트 조회
	public List<Map<String,String>> getDetailList(Map<String,String>  formData);
	// 수주접수 상세 리스트 조회
		public List<Map<String,String>> getDetailList_v2(Map<String,Object>  formData);
	
	// 발주서인쇄정보 조회
	public List<Map<String, String>> getOrderRecvHeader(Map<String,String>  formData);
	
	// 특수로직 (발주서인쇄, 분할납품제한 고객사) 조회
	public List<Map<String, String>> getSpecialLogicInfo(Map<String,String>  formData);
		
	// 수주접수 저장
	public String saveSellerMpIvObtnodrReceiptDetailPop(Map<String, String> pMap, List<Object> pList);
	
	//물질정보등록
	public String saveSellerMpIvChemicalInfo(Map<String, String> pMap, List<Object> _list);
	
	// 수주거부
	public String saveSellerMpIvObtnodrReceiptDetailRejectPop(Map<String, String> pMap, List<Object> pList);
}
