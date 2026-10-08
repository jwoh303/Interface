package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

public interface MasterMpDsOrderInfoConfirmPopService {
	// 조회
	public List<Map<String,String>> getList(Map<String,String>  formData);
	
	//주문취소
	public String cancelOrderInfo(Map<String, String> formData);
	//발주수정
	public String modifyOrderInfo(Map<String, String> formData);
	//발주등록
	public String regOrderInfo(Map<String, String> formData);
	

}
