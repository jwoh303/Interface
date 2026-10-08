package com.koreab2b.mro.seller.mpiv.service;

import java.util.List;
import java.util.Map;

public interface SellerMpIvDeliveryRecordRegService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  pMap);
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegList_v2(Map<String,Object>  pMap);
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegList_v3(Map<String,Object>  pMap);
	
	// 저장
	public String updateSellerMpIvDeliveryRecordReg(Map<String,String>  pMap);
	public String updateSellerMpIvDeliveryRecordReg_v2(Map<String,String>  pMap);
	public String updateSellerMpIvDeliveryRecordReg_v3(Map<String,String>  pMap);
	
	//거래명세서 취소
	public String delSellerMpIvDeliveryRecordInvoiceList_v2(Map<String,String>  pMap);

	// 택배사정보저장
	public String updateSellerMpIvDeliveryRecordParcelReg(Map<String,String>  pMap);
	//납품완료 조회
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegEndList_v2(Map<String,Object>  pMap);
	public List<Map<String,String>> getSellerMpIvDeliveryRecordRegEndList_v3(Map<String,Object>  pMap);
	//납품실적 삭제
	public String updateSellerMpIvDeliveryRecordDeleteList_v2(Map<String,String>  pMap);
	
	
}
