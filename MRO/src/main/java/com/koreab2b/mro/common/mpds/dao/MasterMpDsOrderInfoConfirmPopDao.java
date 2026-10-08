package com.koreab2b.mro.common.mpds.dao;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

public interface MasterMpDsOrderInfoConfirmPopDao {

	// 조회
	public List<Map<String,String>> selectList(Map<String,String> formData);

	//주문취소	
	public String delOrderInfo(Map<String, String> formData);
	//주문수정
	public String updateOrderInfo(Map<String, String> formData);
	//발주생성
	public String insertOrderInfo(Map<String, String> formData);
}
