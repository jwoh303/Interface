package com.koreab2b.mro.buyer.mprq.dao;

import java.util.List;
import java.util.Map;

public interface BuyerMpRqRequestQuotationTempDao {

	// 조회
	public List<Map<String,String>> selectTempSaveList(Map<String,String> formData);
	public List<Map<String,String>> selectTempSaveList_v2(Map<String,String> formData);

	// 견적의뢰
	public Map<String,String> requestTempSaveList(Map<String,String>  formData);
	public Map<String,String> requestTempSaveList_v2(Map<String,String>  formData);
	
	// 삭제
	public String deleteTempSaveList(Map<String,String>  formData);
	
	// 저장
	public Map<String,String> saveTempSaveList(Map<String,String>  formData);
	public Map<String,String> saveTempSaveList_v2(Map<String,String>  formData);

	// 견적의뢰 결재 상신 후 KEPRQDT.RECV_FLAG = GD 로 변경
	public String setRqdtRecvFlagToNg(Map<String, String> formData);
}
